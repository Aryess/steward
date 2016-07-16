class AccountsController < ApplicationController
  before_action :signed_in_user

  def index
  end

  def create
    auth = request.env.delete('omniauth.auth')
    acc = account_from_auth(auth)
    @account = current_user.accounts.build(acc)
    logger.debug acc.inspect
    logger.debug '------'
    logger.debug @account.inspect
    if @account.save
      flash[:success] = "Account added!"
    else
      flash[:danger] = "Account NOT added! You probably already added it."
    end
    redirect_to accounts_path
  end

  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html
      format.json do 
        if since = request.headers['If-Modified-Since']
          # binding.pry
          if @account.updated_at.httpdate > Time.parse(since)
            render :json => @account.to_json
          else
            head 304, 'Cache-Control' => 'max-age=1'
            # response['Cache-Control'] = 'public, max-age=1'
          end
        end

        # if stale?(:last_modified => @account.updated_at)
        #   render :json => @account.to_json
        # else
        # end
      end
    end
  end

  def destroy
    Account.find(params[:id]).destroy
    flash[:success] = "Account unlinked."
    redirect_to accounts_url
  end

  def omniauth_failure
    flash[:warning] = "Oh no, you didn't accept :("
    redirect_to accounts_path
  end

  private
    def account_from_auth(auth)
      provider = auth['provider']
      uid = auth['uid']
      token = auth['credentials']['token']
      login = auth['info']['name']
      login += " (#{auth['info']['nickname']})" if auth['info']['nickname']
      aux_token = auth['credentials']['secret'] || auth['credentials']['refresh_token']
      expires_at = DateTime.strptime("#{auth['credentials']['expires_at']}",'%s')
      jsondump = auth.to_json
      {provider: provider, uid: uid, token: token, login: login,
        aux_token: aux_token, expiresat: expires_at, jsondump: jsondump}
    end
end