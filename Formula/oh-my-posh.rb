class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.3.tar.gz"
  sha256 "8d5fda43bf35b4837a7f4b42d61c02a27848e21767edd0a4762b9b2c22c8efb4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6888f1bff737756ce661bcf5031c172717ae442ec48526847a9722079b2d4cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0184bdc7b3b1a694e496481fd43c82c1fd4613eb0e4228a1dde2d5c9d5c45086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aee2d5bcff824a622dcf1e02dea7fb101429a5b5f51124947e715db146643bae"
    sha256 cellar: :any_skip_relocation, ventura:        "9f45928484890334e8c4a970df22ab6795bbb9392ac5b385e92f84b8f4972676"
    sha256 cellar: :any_skip_relocation, monterey:       "747e7e5c238c631b0de5faafd56387d68eac26419810947989dff504b6a9090d"
    sha256 cellar: :any_skip_relocation, big_sur:        "81c0c687dacb051a41ac3c61627f76557cfb206f7c0a0163bd19dae7ad9293ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32cfacb4e153018fb7f18b8668b8acaa20e43452dcb54119db27e0df0d7ceea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end