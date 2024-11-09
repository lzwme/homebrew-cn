class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.12.2.tar.gz"
  sha256 "2c77817eb81ff2b49fd620fbf3285ab226b53ff1c71ac042ec241855cd5c91f7"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3153ccd3363f601614139f711ace1428eb5190eec59a0c079024836479c49a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae905f1257932806c8db656e2a757dbdadd1e2beb24e6840ad58a4c37c35cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52842d10d88c62d752b13cbf40d51786833b736a3e98544b0c2eb76b59c09724"
    sha256 cellar: :any_skip_relocation, sonoma:        "9857b499193fdb0304272c746c494d03d611c33a9e47c115fa22a374cc1fa7bd"
    sha256 cellar: :any_skip_relocation, ventura:       "ec73be661e672446e5b9b5476509dbb33d004a9f02545be8d69b0918a1425531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3c48f59c28ad328db294633190d3de6b6cb95c7c13ba971b60bbda50580bc3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}conduit --version")

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