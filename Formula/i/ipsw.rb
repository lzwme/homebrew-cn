class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.688.tar.gz"
  sha256 "954bc03d532b5d5892e040e4561cbdf18414c64858eef38f4a974662092de03e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8196201f70f1224a5b886d0abd05154e56953e99d02dd631c470665dcaaeb130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd866015b75c4af0a57ced445af4c8ce5380a49e7e1b4b8a0b14ae4cc9a03ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606bedf58eb1802f44444909f94c41245d2e0392b6047677369b19218e8d8184"
    sha256 cellar: :any_skip_relocation, sonoma:        "91edf7273f0d28176cc1a5e048bcbae992bd1e3029bfdaa8cbd8456f9c098573"
    sha256 cellar: :any,                 arm64_linux:   "df122972ee784da36311677a4a55ffb1facef5f35c9e02e63994a167ffbbd437"
    sha256 cellar: :any,                 x86_64_linux:  "888295f64352d48dfc6d457b7c074f25513ee8ada12c9405585de5ec2364ed11"
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