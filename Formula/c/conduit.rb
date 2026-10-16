class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://ghfast.top/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "d60f7fb4a250634d7efa298ccd381db1644a0f8668ab98a979dcff3f2f503654"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e1441e21a382bc48ad2a941371c6cb2ea62397827e16a880121c6b59f7d2d5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50995df118108fbdfb84d8f0175e026bf8295151819a99a5d606f91eaa6e1179"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42c1f739e43ba882f1cadbf7396658fee8d2cc90ff394b4e1c4b3b441a1c52c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ee95ada5c845e5f66fe42eb8d9b7f65c1dc9babd54ee472e92c1515620a5fb8"
    sha256 cellar: :any,                 x86_64_linux:      "1a9d3ddc6a7dccf5622442115e0f3ccb2b382eaafe44aa9d6d7c3666f2a261b5"
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