class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.5.3.tar.gz"
  sha256 "de2855ef79f9232d724929cfd3ed9d70f97d613c3f05b9325c5ca5a7a3b48a19"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aeec8147d268d2c03b76a858038cdb4973407590281cab0f0888909d56e48bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0f45161dd4f18c10e2de3682f5f7e915f9cbaf2ac594c82bf19fcde90666c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d32df9e95271dcc4b968b28229ad30a487fbdf907b041f7cf373345782e4ce22"
    sha256 cellar: :any_skip_relocation, ventura:        "959b828467611a3c468e68df7bca817bb06fc6a6819274be1224e11314189076"
    sha256 cellar: :any_skip_relocation, monterey:       "abd416d6f8dff5410d2c51b8123a7fd316fb757fae7f339ec5c504f36a79dc4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ca753ef26b21d43777833c0ab95edcf05dc51821b4446de2c06951a8f8c1d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b63ea7d07353571ca43c871089fcd00aa444491b77ce548043421830cdf24bf"
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