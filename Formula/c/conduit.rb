class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.13.6.tar.gz"
  sha256 "364a7c2ee713b3e776a57a211c915d0813c3398fd9af0492d33ebdd3eeb5d16c"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef81acc3fe81686bf5e478644f5ca288b77027e75d8dfd1cf62a3b66770600bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa34468427feb8b04ae5397b37455350624a02df7f441cd5f0d006d47347a9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "447797bbf2994b87a874f24d1b99cae75c77eaace536903ab750e1855719cb07"
    sha256 cellar: :any_skip_relocation, sonoma:        "333725673fee0c241702ab8478eb2d22bf80bdff4a1a5d176af255ce92d4786c"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb9858fc5f70aa69f8ac82f01e72d6981254573a31e27cf6573c9cf1395d2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c25923e90629d6b6ab7dff3dcb2271a06e7662b2477bb15a2f849771fe82531"
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