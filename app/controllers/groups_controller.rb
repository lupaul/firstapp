class GroupsController < ApplicationController
before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

def index
	@groups = Group.all
end
def show
	@group = Group.find(params[:id])
	@posts = @group.posts	
end
def new
	@group =Group.new
end
def edit
	@group = current_user.groups.find(params[:id])
end
def create
	@group = current_user.groups.new(group_params)

	if @group.save
		current_user.join!(@group)
		redirect_to groups_path, notice: "新增討論板的您成功辣！"
	else
		render :new
	end
end
def destroy
	@group = current_user.groups.find(params[:id])
	@group.destroy
	redirect_to groups_path, alert: "討論版刪除囉"

end
def update
	@group = current_user.groups.find(params[:id])

	if @group.update(group_params)
		redirect_to groups_path, notice: "修改成功"
	else
		render :edit
	end
end
def join
	@group = Group.find(params[:id])

	if !current_user.is_member_of?(@group)
		current_user.join!(@group)
		flash[:notice] = "歡迎成功加入本討論"
	else
		flash[:warning] = "你早就是本討論的成員唷！"
	end

	redirect_to group_path(@group)
	
end
def quit
	@group = Group.find(params[:id])

	if current_user.is_member_of?(@group)
		current_user.quit!(@group)
		flash[:alert] = "你已退出本討論板了唷！！"
	else
		flash[:warning] = "你不是本討論板成員，怎麼退出啊ＸＤＤ"
	end

	redirect_to group_path(@group)
	
end
end

private

def group_params
	params.require(:group).permit(:title, :description)
end
