class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.0.0.tar.gz"
  sha256 "f18002546228815c70937dae9e90f6f707ea5f3e24d3a01fbb34a7e9a0d69661"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1b4445f08a21c1da22181ffd6877e12ae827221d0aa81942fe270af0c4f5912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f00e5e83cce7bde3c6d7ec3a1995ebbc6e4359394616c2e2e6268951581ef51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e7e2425a688163a77fa67a4cf68c83fe15affddd8311902da568b6df3b2ca5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d319d92feed947527b0f05e10cda86184c299e30316c1e699225f96dcce84c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "090cbb194c0190a969b951ceae056fc6539435bf6eba4fe692e3eeee8a5cb531"
    sha256 cellar: :any,                 x86_64_linux:  "dacfe5e7b54f8119fbb1c1d3585652f912372da45d5cc48bc5e601204361e404"
  end

  depends_on "go" => :build

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