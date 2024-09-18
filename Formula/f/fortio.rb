class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.66.4",
      revision: "cdd54aa8590053e5c4be57a0e257429661f14794"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "773cf3023366bd2880abb13aa63fd6ae591ecd63fd850b0b265814abeaa0daf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8d072dff951ec8504f227d40b19c969ad34e12eab3e80c5b54fec653deb696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f7f1907334df4b99194a86be2a2de58eb411535fac95b14c14336657a6ffacd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55177d54797b422b75bcd6da3bcec0074056420cb9a8347790f64e17c7152a3"
    sha256 cellar: :any_skip_relocation, ventura:       "d419b5f78c1446b957b07417d729eac8551e62c184a1162f0c32619df63635ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8e2f97c592288213bdd46490a151bb0274ba9c46888d6bd24045e83f8ced83"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}fortio",
      "BUILD_DIR=.tmpfortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}fortio load http:localhost:#{port} 2>&1")
      assert_match(^All\sdone, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end