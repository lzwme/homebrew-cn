class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.681.tar.gz"
  sha256 "aed899d67279f170e159f73b2e7b7d237d0616f27864b8109ad473083b57af37"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ea258133adcb4ae4ea6823b15971d7b204dc2f65dbd84c23bbf8475aaeb9675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c061754ae9b213fde38cf8f40f6769766c464f4f079f73a318bc0995a2978722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf252e3c3fadae7925623f8705795590f1586940745b1e50885ff33a4fecc47"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9bee4d8a3641c7b8bd95c10ef9bdffae504d66ed7960a4ec322049159d5cee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd34dbd73fd0d618aa99242e82d1b0f55280026ed5ffb8349b34de52cb682b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6632eeb8ee0376658d64a1331a5e334e978eaeb59ab5502ea4944a4a187e9fd7"
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