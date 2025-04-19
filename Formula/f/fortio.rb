class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.69.3",
      revision: "23bcb77950e972514dfd745ce12b473a6a5a2d7c"
  license "Apache-2.0"
  head "https:github.comfortiofortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d18740b39ea451ede93d6200a91ab1b84ad4e1558ebad62d999388081c6c1f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc303f4f9b22b3b0b9e7f87f117b1532c4f7831106e20089657dc948a49e596"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec3e6fb27d0eabc62e460f9cafca6525ebe6a706d0c960d99e111bf8851161ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ec30f49886ce00374e94df1cdecdf53216573c311fc9078cc552b1485df7de"
    sha256 cellar: :any_skip_relocation, ventura:       "08e47380eb7f0e02dc3c4ed34a325edd4c851e8d459de7321ea017f4e4595eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b44876472eff64f7fb317a44d4090d8134ee9dd859eb9e335b056d7c5ad344e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b0c47bc12d854e0f8281b0ad75d870999159b163fdc0beb692e383447f725d"
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