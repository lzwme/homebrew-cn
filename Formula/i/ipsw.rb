class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.656.tar.gz"
  sha256 "af1ea4070dd2e9b0e244f7d98f63bfbf473a03eea6f437c7820095a86c37b0c4"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90b9bf7e5a6c76490867e811af21e66dd6b72383d3de2e5771a6f18f0f192b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd63081674dbb69e062d0e2eac001943fdbef11985ef1522588ec9e884dcb8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df96e6aed8d36a4342ed4cbd5c0d673c07ee8efa1cfa262b4a755f44ac7b699d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b08c0904476326a7736c3cf13a263e3f45278c7d3efb7f17c79b65e065d56b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abc97d81aa0649ffb3bef98e1a3c8066cdc43a3fb103cbf0d674fbdad53a803c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dbe7722e221922fb1d2550d5434c39e59ee5386c4ecf013f9010d15615d6842"
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