class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.4.4.tar.gz"
  sha256 "353a35820381f70cbc63e106bb7b32d4500b01341cf6f74cae5f0f4f6c29e2f6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18404beaa784e7d3192d7e963f275f7c72c39fc01321735ac0c8dfced205b74f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3830980be84cb7bc40ac1050cc77fa96c294b02cea730a569c9737a5d89f4a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b403d175ef4a7e34ca2ecb829a9581b676ec20acb0cd280f48cc236d37f0044d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6bb7e1aae939d032e9bbe63fa1e43f9218f20ad355b93aad8471290b723f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb6c0f63278bfdb139998a02c3f2762048308277a1076a215738dc6cd269d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3b3b897a60dc928f7a7dea75d51e4d97f45f5946bfb989a067d9bbb38b0e37"
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