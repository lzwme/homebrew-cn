class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.713.tar.gz"
  sha256 "79e603918a47a6ca9dbe889bab44b4c944150714af6baefa8ef3b55b872d0c03"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b122b46dc023ffc1df942e764c54ab27e988d6c80b351668e13278887bd78cd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d25e781ca2e8f9bb1dface6b936493faef3a5bd4e14e35dc427555f9ff62f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb86ffca710c23e3a759cb0c730fac419b5161236c4a3bcc34840fafac32ada"
    sha256 cellar: :any,                 arm64_linux:   "af6165ebcabec96cd32b320b689225429563bf29bee1662c9320068b16fbc41d"
    sha256 cellar: :any,                 x86_64_linux:  "11d32f9214230f33482fc8345f5c6dcdcaa37510fdd817bdde1c268ff3ee86a4"
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