class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://ghfast.top/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "65cb956501c8fa2a45ea123d43b5b752f967e71271f55ad01958a323991c0024"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49f5e12e2a8f0d0e0fcd35a0f630f713af8eacc11fa4295e2619997389aa0d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80330aa1349e2cee3978098a2e3d2d5d7b17bf840d6c7b9b0bdd39fce70c1097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7127dd873dc5bdd262fa14df67411f8ea7918b3ae0682b16423ee6c5a117f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b81ceed3e24a9c34d022946ae65319da56512430c84f7238107f3dbf1d241ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdd95336638c2600b047b22645f367a273fa66ee82a66a3559393ff0f8d2bedd"
    sha256 cellar: :any,                 x86_64_linux:  "ddde4a1cdea456abee3d80962d189fabeecc72f1476967bf7ba1f4fdf47d4023"
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