class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.0.1.tar.gz"
  sha256 "c74922374649783d5459638438adf4b4850b6c180eef958e25c5eb8e68604dc9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99607fa3aa1a380b61357e71c3bdb21d9d5db8ac7a81deb057f337a941406c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf4288e1a781c61a058483af301655d1c1a816eec47a173000b28a5a6ca6baf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c51bc7f41168df42a74b849d32705559d22e854dc780e3473ceae3a3036b404"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b03f47e44431182f82d53317c337098ccc12a698c9cf4936a9e02f3e78951f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0ec7c368425e87fa4da412fefeb383b98b54930aef7989946f71fe1daccebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245bdc69340c6bf210fa10784efad5a54857b40766ba0067f07bf9a7d206cf24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end