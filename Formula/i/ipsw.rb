class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.669.tar.gz"
  sha256 "d99a8b21120603b5388911df6c06538ff40d847b7b0096b34c525033af52660f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba56905e3367ae91ad7bb6560eacb5199b18d419f48c37d4ae1bd5ffdc38c3ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfcb62a8416a852264975168908d20ee399d87280e34bb49d159253fda3c3b52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b770adcaee3b66a1ab580a0234aec1ff1f6995a421ab1033b3cf29c205ce541"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7f0baa96e6084c98dbb973317106d327a5fbe41a6d9d42177703128f211ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "819b7238c782a116c046009c279e8ba2282e0a1e46eaae03fda08b0a65b72039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1e444fe67660a535f17826c8078106a94085ea8ddde56297c41945b92942c0"
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