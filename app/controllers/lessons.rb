# show all lessons
get "/lessons" do
  if logged_in?
    @lessons = current_user.lessons
    erb :"lessons/index"
  else
    erb :"users/new"
  end
end

get '/lessons/:id/edit' do
  @lesson = Lesson.find(params[:id])
  erb :"lessons/edit"
end

put '/lessons/:id' do
  @lesson = Lesson.find(params[:id])
  @lesson.assign_attributes(params[:lesson])
  if @lesson.save
    if request.xhr?
      return "success"
    else
      redirect "/lessons"
    end
  else
    erb :'lessons/edit'
  end
end

# delete a lesson
delete "/lessons/:id" do
  @lesson = Lesson.find(params[:id])
  @lesson.destroy
  redirect "/lessons"
end

# new lesson form
get '/lessons/new' do
  if logged_in?
    erb :"lessons/new"
  else
    erb :'users/new'
  end
end

# process new lesson
post '/lessons' do
  @lesson = Lesson.new(params[:lesson])
  if @lesson.save
    current_user.plans.create(lesson: @lesson)
    "/lessons/#{@lesson.id}/edit"
  else
    @errors = @lesson.errors
    # try AJAX
    if request.xhr?
      # Sinatra doesn't understand @errors, so send the errors back as a json object
      content_type :json
      @errors.to_json
    else
      erb :"/lessons/new" # show errors
    end
  end
end
