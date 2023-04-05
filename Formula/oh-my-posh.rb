class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.25.1.tar.gz"
  sha256 "4b55485bc0f1eb416f70bc9ceb5c0208de61b720b3a88ef8a1705e616fbac2ab"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e35b806d842b4884696547cbdc764183c0d52003e3b0339403df03e08483ee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24325a99cbd0dd8c42f5a7b6a01bf3f8f9461750bacfff64033f1ad842f8dcef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0fd8eb2ba613342d803d40da3a46cc8f7636f9980d8fddea5684e583559fba4"
    sha256 cellar: :any_skip_relocation, ventura:        "e88c2125e5e4a83e9535c60853e8d995b37f0bcbe435d33a41b7a788bdb66e51"
    sha256 cellar: :any_skip_relocation, monterey:       "2530ccd2e4b13a18907921afc2e067e948fc9c51123e4229395e1e96f0778de4"
    sha256 cellar: :any_skip_relocation, big_sur:        "affbdf88cf11f20bd68b45c912affbfd4868cd4cd86943178553a4f5bee0bdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a5762e0f02e4013f5e97a760108e6a9f8596247872493bb4f6a5c630da12af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end