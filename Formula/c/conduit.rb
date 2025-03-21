class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.13.3.tar.gz"
  sha256 "5d685430b75c4e047cb09041070773947ea27fe087af0c96559d3bb156d0f778"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f64ca36cff8bb14765333978d22a6d3a587ddd5709489f20b9997aab6b74f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ce0397ccde91413e6edcf124e5517369a3894d855df2310de487153e5d25d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "822c1294cb25c2a2afa8151fd06f930bd53d83e9352b63f4473dc0530509a90d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88d6e783199b79fdb6c58760588f609b74d6f06aebc1efc46bc994c8da022a3"
    sha256 cellar: :any_skip_relocation, ventura:       "ef5647d7bd087d52498671c20fa933fd03ac487743b828fa965399d21878c04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24524f612873cf8023a12e219af339f62846c6b4b65af2f4793e8de4eb3934ac"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath"output.txt").read
    assert_match "http API started", (testpath"output.txt").read
  end
end