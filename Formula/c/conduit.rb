class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.12.0.tar.gz"
  sha256 "a4855e1c32af520a9bdcdb86af6f7923d85f51b2c535799fb7058b2ade6c3982"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c6f336b6245a1f347ec693453827291ad419bcd68809ce8eab88dcf8fede4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c3268384993bd8132405a7edebafb0e6bd9cda264694f3122675ed54ae1b57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00864819366d89dc6d5e561ea72ab4f0f0da60c4db1b75ff0bcb982180fb3e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "d040b0e96cc2c18f65304b222d77a81405d707d3e13fc6a7221800c827a7fea4"
    sha256 cellar: :any_skip_relocation, ventura:       "aa9addfefac099aa55812475366e3ea8ebb2effaec288a175e84c910daa3c6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acf074a42a5eafd0d700a2723a9106b1aff0240ef4d4b7857729390b068e5a45"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath"output.txt").read
    assert_match "http API started", (testpath"output.txt").read
  end
end