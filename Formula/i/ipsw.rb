class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.691.tar.gz"
  sha256 "0dda70e415cc5570ce65006e6a6a6ba4980678ada4e1cd8d8af2a92c4672145d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42360c775cb263fca1e146d95978a185dba95c31d7790d1302b3306ac7ccf64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1f347707b3361d839ba543976ef4de68009f45469722ce5e10fc00989f9680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eeb1e63b7b509ac81d2853a526f8ad0a49edfcba2c243ca400e4205da65a83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd6a4930a0f280a7f5c56e66f16e74c0a42d31b342d528108cdc20306f6cb8f"
    sha256 cellar: :any,                 arm64_linux:   "ce75fe58ce9b92b7dc5aeb3095d9366a81511ae7f1a16be93bbe727d6926be7a"
    sha256 cellar: :any,                 x86_64_linux:  "209b763cdd163baa6cf851c035254ce2352e3789aeed1e2b98dde1b7cd7c4cb9"
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