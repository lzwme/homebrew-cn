class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.684.tar.gz"
  sha256 "a4898abaa1c6d37e282c0f63f1b6452871895410f70d8416e37a912c5ea87849"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a329e3dfed652a7f7df486d07b2feb9aa054b72878c16a9343b7e3d319c513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d956f8d44a0d1c93cee95f5c5a084de05d3137d334bb0a70b50eceaca2030b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad60d738ca1feee7e49c09449d89cd7ae04fa220f482325102ecb77769a1b180"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4015e3264bdb28b3c4520c1426ff7a5ab02430bdf895cacee9107bacf4850b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5d9c782d184c5d1dfa8e1cd6b74539ba66d4017d8ebb3f78688ec10947e297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2121c69d58e4aaa7a90218ae63aebb29852b1b01bcb16484ccbaf0b8a8c45cd2"
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