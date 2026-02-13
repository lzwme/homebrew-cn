class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.651.tar.gz"
  sha256 "5db4bb632ad94283cd0d52831e1999f8259494aa87b3c36a1443154c08b6f45e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45beed6d5de11b1e3877981aa1877aa3e59997c009a1c28986e0502ab36fe631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88483846a0b149bb2592f90533fac9bfd540724aaa8b58bac13d53f17211b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a04c4cc817bdf59fdddc55c500dab60777efcbd9b1767a07725a1251c5dbc81"
    sha256 cellar: :any_skip_relocation, sonoma:        "137a7c8dfa75768de1707f80a2bffca2fe699eb7d9ad639f0f93c33289ba0143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db3f5b3ba9232066620ca0d9a0d9df6a96c28fd99b7d672ad6838d24438c5c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0bd68ad4f373e8d34febfd1f7eb196fe96473636c38dc738680f29b51822501"
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