class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://ghfast.top/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "6c42bf36748066202f7247402b9a94dad2467eb02e98bb991711b745282edac8"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "796dd8482fbb7692449669fb6f95c0c342b61ddfc4185addbece04145802c031"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bd4b19cf8735b7775e7ad26a2fe1a78dfc39c71acd4d44cc0df5ef7d13df787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "114c59948469b0d8c5bed07b7471aa1c511c59f5eccff3458358cea28719c00e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "434e809a0d1fa3cc6730a253e0efa2a2924fca149269f001b1441a912eccef2c"
    sha256 cellar: :any,                 x86_64_linux:      "30a9e35e7f9d7fa47a2e9a8f36ee466843542c542a9ceef92ac58a3bcb093ca1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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