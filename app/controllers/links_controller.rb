class LinksController < ApplicationController
  # GET /links
  # GET /links.xml
before_filter :authenticate_user!, :except => [:index, :show]
  def index
    @links = Link.find(:all, 
											:joins => 'LEFT JOIN votes on votes.link_id = links.id',
                      :group => 'links.id, links.url, links.title, links.created_at, links.updated_at, links.user_id',
                      :order => 'SUM(COALESCE(votes.score, 0)) DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /links/1
  # GET /links/1.xml
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.xml
  def create
    @link = Link.new(params[:link])
		@link.user = current_user

    respond_to do |format|
      if @link.save
        format.html { redirect_to(@link, :notice => 'Link was successfully created.') }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.xml
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to(@link, :notice => 'Link was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.xml
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end

	#Vote Up a link
	def upvote
    @link = Link.find(params[:id])
    @user = User.find(current_user.id)
    @vote = @link.votes.create(params[:link])
    @vote.user = @user
    @vote.link = @link
    @vote.score = 1
    
    respond_to do |format|
      if @vote.save!
        format.html { redirect_to(links_path, :notice => 'Your vote has been cast.') }
      else
        format.html { redirect_to(links_path, :notice => 'Error recording vote, please try again later.') }
      end
      
    end
  end

	#Vote down a link
  def downvote
    @link = Link.find(params[:id])
    @user = User.find(current_user.id)
    @vote = @link.votes.build(params[:link])
    @vote.user = @user
    @vote.link = @link
    @vote.score = -1
        
    respond_to do |format|
      if @vote.save!
        format.html { redirect_to(links_path, :notice => 'Your vote has been cast.') }
      else
        format.html { redirect_to(links_path, :notice => 'Error recording vote.') }
      end
      
    end
  end

end
