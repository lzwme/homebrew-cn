class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.7.0.tar.gz"
  sha256 "81d60c52850d0d056c09cc21a08ed050bc67b2b1c5922f84fdf22e993a935d02"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a357a73bdac27ffd9bf8f0e32d586cd442f75b35e1225038084034bec32fe73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72913a7418c6e0b3f6431536fcd791d34efb974366bc7749c7ed31ffe2a136b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6956d6af458adb3c982284f0e236ab71be3b106983539efa1fb4cf4d56eafe06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0469b6bbaa0c252ae590cd08ce14329632f40fe251a6226f0ebde0d649e9a41"
    sha256 cellar: :any,                 x86_64_linux:      "ae5a913baf6a4d5303efda3e99a6f05726b218a063d62b272e633eec19f79c39"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
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