class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://ghproxy.com/https://github.com/ConduitIO/conduit/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "a7652015d93034569215061ca963a82faa806a3cbac08540db78562642c874a3"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5a58fe7b14d129aaf7f13b1062e0047c56aa9780d5d6d4483bc9ea6f7c3db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a833c6405d91520c5b55c198192ccbb1dc9d0e52b0b801a10ab4aa022f29162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f09e52aacf8254c2deeeeaf7078f60e41b52b3fa6b9984df11f4c6553e89f29"
    sha256 cellar: :any_skip_relocation, ventura:        "43bf3553a1779d0704e8eede29834c78bc2dc85c8ebe9f6f0b17645b789ce47a"
    sha256 cellar: :any_skip_relocation, monterey:       "e23ba93ab8e458f7c63709106390be79d4f7dd33d624c4b0488d7892d6a15262"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cae8d6336239b5c0ec18514a8752594c259fc4d05215401d204313426a4b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ce3858bf0f83e6c1133760d926aa3b75b378c4546cb916efb7304485bd9bc8"
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
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin/"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc server started", (testpath/"output.txt").read
    assert_match "http server started", (testpath/"output.txt").read
  end
end