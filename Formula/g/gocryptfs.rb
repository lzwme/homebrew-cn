class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https:nuetzlich.netgocryptfs"
  url "https:github.comrfjakobgocryptfsreleasesdownloadv2.5.0gocryptfs_v2.5.0_src-deps.tar.gz"
  sha256 "eed73d59a3f5019ec5ce6a2026cbff95789c2280308781bfa7da4aaf84126a67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b98a2f222a21d23ef9c6236d4249c940ce9312229395f0f44b6cc9c25f5fe5ba"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system ".build.bash"
    bin.install "gocryptfs", "gocryptfs-xraygocryptfs-xray"
    man1.install "Documentationgocryptfs.1", "Documentationgocryptfs-xray.1"
  end

  test do
    (testpath"encdir").mkpath
    pipe_output("#{bin}gocryptfs -init #{testpath}encdir", "password", 0)
    assert_path_exists testpath"encdirgocryptfs.conf"
  end
end