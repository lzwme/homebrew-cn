class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.572.tar.gz"
  sha256 "c3ef2c47ec9f1ad937cf1c17e798214df9aaa0f39ca735f745de11d0ad7c2597"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9790c41b8412da12d61f3fb8150bffa6f4b3bf089b9a4c5f3754cdaef404c9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135e29f34e7b39cbabc5018273d6607de93a86400858956cf2c027fbef9f1e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5ff4514c757a6ef7bb6700c60cf7d9465b08cb1079b0dbc16b43ca113594f1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "160d37fe2a4bb4500d3d9aaa8f2c45d3eb284ac3a7a919a3f55b3372fb93312a"
    sha256 cellar: :any_skip_relocation, ventura:       "f297c7deb3053f71261cb7a887d1ca3dff227d08e69c351f4f670d16f5d60201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f72330b0666f06b030745ea48568cb0d68021a7965bb6bd7c97f4afdfeb48a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end