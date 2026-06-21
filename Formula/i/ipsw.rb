class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.696.tar.gz"
  sha256 "94242c6d4366b96152335d9953515e0446475670c257e3a770d12158a5934b38"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4a42606743becef1500f417121c48a16b739bdfab4f597413b01f13d7419d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a051dc7f9160513423264bd6a9eebd85fae5711916595c1e8bf4697e14a91b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9f1c984c53e342e7b8ff541f84ea62ee35d96bad126d9f6ac2f08cb1f388fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "39325dc858caddeba4f9079dcf0ceff47defcc57b9b6ffefdaf301d2fa4da35d"
    sha256 cellar: :any,                 arm64_linux:   "70f89089ddeb98a042c8579275e23713c17d8ef4a8e7293af62ad5ac6cc4479e"
    sha256 cellar: :any,                 x86_64_linux:  "330a20b8beb1819f65aab9ce5c9d5dc58cda8aa2197bf7b2bc96226fc9e44280"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end