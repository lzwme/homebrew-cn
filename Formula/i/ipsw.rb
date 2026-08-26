class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.712.tar.gz"
  sha256 "b42e583fb25bd85480ee87fb9ea04e26381cdeab20ef3b2872f2ee62492a8c05"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f78b451365cef64a6b083522ecbcbd153637fc2d1c8de1a18907627f249a8a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7cca1e1b51ffcd1eb9ec1551527d9163cc5b46c6e084f16a6173dceadddc356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7609d86df613583b19725bf3a52154dcd79cc20f70df57188ef1eba5b66f1463"
    sha256 cellar: :any_skip_relocation, sonoma:        "92e2577d854c5d93bbc62f1e4fbcbb00466f3139cc9ae6055df36a7752bfd65c"
    sha256 cellar: :any,                 arm64_linux:   "37dbe24435b9ea0bf57fe2a286123e92e6b57d3da6a2624439df4e31f6d79473"
    sha256 cellar: :any,                 x86_64_linux:  "8b0af52369cabc722262941a4bee0fa9ffd3f8e94f599f6f32bfb2c6601ca5dc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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