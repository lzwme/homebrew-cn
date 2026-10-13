class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://ghfast.top/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "676738e6403dfb67d735a17f01139f161566b751801b1e8184508cc83a1ff616"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e24b53d5933d10d5c625468465a4b879632b99d44f9aba87fe6e4697e42ba2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d56b4b578213bdc214e27b14c137936530fa15750fc48683566e1c6e8c7816d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41eed4d932b61c1891fcfeb9dbaf9ef71c12ae6ac65468a33fc10fe9c6d5011e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c20d75dd5b8d2537d9db6df671b6dce79a1c6eaca69d2788adbbecd71350ee86"
    sha256 cellar: :any,                 x86_64_linux:      "e38306725064923f101c5fe0299269443e5b170866edea33bcb1fb61d2fa5ba5"
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