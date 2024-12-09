class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https:github.comlaurent22massren"
  url "https:github.comlaurent22massrenarchiverefstagsv1.5.7.tar.gz"
  sha256 "7e7dd149bd3364235247268cc684b5a35badd9bee22f39960e075c792d037a8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9c626a0b4043b935fc894829d76eccb1b5e4005bb74a27c36a2bc6024d6738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90dff661ac5259a5bf2a26401f54d62e551a7799f0c44fd125bdb435e3047332"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737fd5d4ee50a0321bace9f93d01e0e98dd40c5c360425432bce39c04a5805fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9982a61764789498d55b95616ac779d9de1c3ddd6b7f72d449ae28a9894eecb4"
    sha256 cellar: :any_skip_relocation, ventura:       "6d5f4718a56f2b21f8f5b11d9ccb003ffe75914e6e9951735a15fb9dd89de170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4847c67886eae84c917ad14f478f1787532947689235f2edf9d38854740f663c"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath"srcgithub.comlaurent22massren").install buildpath.children
    cd "srcgithub.comlaurent22massren" do
      system "go", "build", "-o", bin"massren"
    end
  end

  test do
    system bin"massren", "--config", "editor", "nano"
    assert_match 'editor = "nano"', shell_output("#{bin}massren --config")
  end
end