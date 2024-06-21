class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.15.1.tar.gz"
  sha256 "70bf6f85546a60d55734ecea5fa81bf264e7b2f3a61472885820421152983375"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bb97b526d3829d65fd7235e79bccc4ee8aa2259dbef30eb609c41cf5bebcb39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5fb68d7491e8e2d3fbf7acd2a0eb1778913d9be6385fc81603c47737938068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0905abc4f66c98b4eddc60f5aa2f61d681f43228083697417f2cbf079d9e88ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "01a349f54db23d2c1f374c94d8e6612063b11c6f5011d69db92e53e94f65315e"
    sha256 cellar: :any_skip_relocation, ventura:        "ffa72dfd57d69c67d243a03fd47e8717d4ec576ac9f3ebb7afa975d19ddd0ec2"
    sha256 cellar: :any_skip_relocation, monterey:       "724d40e8cfe7639a55314e13ae275d74092c37587bbb6de782934303d6a42261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f64c4889db2a8fabb5ceee0ba76a377ec2f697034c15627a33ca081f255411f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end