class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.11.3.tar.gz"
  sha256 "1f0eec7aa64d14c646a6c3064bb4b63c4994f258b644926a6a7a22ff770a4c29"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a461a095e06d284ee6a1694df0a869f91f9fa44f4d8df593e4b14bf66bcea082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e6642945611b6ae84756a68ce566616b77a54cfbf334b4298caff38157e92b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20a31bd4afc780617c9eed944cf76936e4905b7ffb6385af65998655a6d01fc2"
    sha256 cellar: :any_skip_relocation, ventura:        "a031c0fb7e4a693741aadc3fe7b0abad7c0449ff63dec2a450dc4c64407ed94e"
    sha256 cellar: :any_skip_relocation, monterey:       "2098148472ba63b09310352ffec3614026eb13b583c50ff2d03862d58315ed1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7263fb73e3d92fa36358a4fe9ac6cb2cc925755aaae9c0916ad9d0d9ee7ad357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86aa60e5e58fa47988d6c362077aaf1a7fb101d88f982be08b05b3f0f8d4ebb3"
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