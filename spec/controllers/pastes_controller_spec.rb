require 'rails_helper'

describe PastesController do
  describe '#show' do
    it 'renders a the show view' do
      paste = create(:paste)

      get :show, id: HASHIDS.encode(paste.id)

      expect(response).to render_template :show
    end

    it 'assigns the paste to @paste' do
      paste = create(:paste)

      get :show, id: HASHIDS.encode(paste.id)

      expect(assigns[:paste]).to eq(paste)
    end

    it 'assigns a parse to @parse' do
      paste = create(:paste)
      parse = double('parse')
      allow(Highlighter).to receive(:perform).and_return(parse)

      get :show, id: HASHIDS.encode(paste.id)

      expect(assigns[:parse]).to eq(parse)
    end

    it 'renders with pastes layout' do
      paste = create(:paste)

      get :show, id: HASHIDS.encode(paste.id)

      expect(response).to render_template(layout: 'pastes')
    end
  end

  describe '#create' do
    context 'valid attributes' do
      it 'creates a paste' do
        expect(Paste.count).to eq(0)

        post :create, paste: attributes_for(:paste)

        expect(Paste.count).to eq(1)
      end

      it 'should redirect to the paste' do
        post :create, paste: attributes_for(:paste)

        expect(response).to redirect_to(assigns[:paste])
      end
    end

    context 'invalid attributes' do
      it 'does not create the paste' do
        expect(Paste.count).to eq(0)

        post_paste

        expect(Paste.count).to eq(0)
      end

      it 'redirect to the homepage' do
        post_paste

        expect(response).to render_template('pages/home')
      end

      it 'sets the flash error' do
        post_paste

        expect(flash[:error]).to eq(t('flashes.paste.create.error'))
      end
    end
  end

  def post_paste
    post :create, paste: { language: :ruby }
  end
end