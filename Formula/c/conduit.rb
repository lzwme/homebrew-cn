class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://ghfast.top/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "09aaca424e413ad171f8b57c075a5f65ccf349a3a41edeaba3a0a660b4ab8e30"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a6d133ab30ebb2e7ea151c9c5679cb30fd2506676986804f0b0c8320ed9c35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3386439a1e63fabfe8ec68738f51e08d3fe3a956db48bb8a76b51260a6636a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11443c850ad528fb5c8f522c244d7644234cc29dade664f7e3c8f800082575f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9930c333b89412b1745efead39e57c0c3f8d911aeecab8576f3f7578ba51b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d81359c2690335cfbec106c7ad54da8f638d3410d1adaf1afd784d49d10e4d"
    sha256 cellar: :any,                 x86_64_linux:  "16016ad10ac4a2553e34e2acc1c27f4fdc5a036f478fce268dd4d69f19237697"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end