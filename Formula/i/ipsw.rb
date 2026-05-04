class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.673.tar.gz"
  sha256 "4b3357a26cbc70f112a37127e879fda05630cfc9a2305f913f85213b0518ec6d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f8f8b51ad39ac744a38f819bb8bb85eb57eef551b09fbb7daddfa4bc4c6a2ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61b4ae41c5cb6309770e0f9a480fd539172fcfb34c8b6f9c5f553da4a3cdacb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac3f3fe0a6406a356ec1cd4ced3fd2e02bfee8e6a8d1be7bb228140a09f975b"
    sha256 cellar: :any_skip_relocation, sonoma:        "693862d6d12eefeaf0d674619c23f23392d3ecb2f52e45d6222df3ffcc0ffab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce684da07eb21cfa2b09ef2cd7cf2b38c29860fc1ba905fddcc7517d92219384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9503f55966a85a48c6b852f07e38dd3e06345a930e07f557475cb0bdca789e98"
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