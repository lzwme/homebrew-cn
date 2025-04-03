class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.68.2",
      revision: "292fcbb234a883d438fbfc78450c10a5b30e4808"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b2f0237a38b977bfeb21fdad7af8e35f2fcb21e410ee2e3986045acc4548e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80e7480a7cedb17f9b194e48e5998bfeec56a9c29f37922e22355ac2aa9cc6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ace7828e4d983c1752a9595cf543529ac2bca52000741208b0efae92755cde5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0cd4d76ad9263ba96199fca406e527aa3df3c8276d568c129c09ee985d4e471"
    sha256 cellar: :any_skip_relocation, ventura:       "c8546383a23934cbd94ff054655c9f2796be41a468024f32dc7a62ad06422669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f33dc12e6963a5fc9a60a777be593b262a8a781dbf4efa865b7f10441043491"
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