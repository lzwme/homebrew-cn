class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https:nuetzlich.netgocryptfs"
  url "https:github.comrfjakobgocryptfsreleasesdownloadv2.5.2gocryptfs_v2.5.2_src-deps.tar.gz"
  sha256 "cc45bdc774592d392c4625c242529c2632bcf1e55ed16d8e81b142fc58616a60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f1c7a5bfc41fce175b2510c052e17b30515de16fa752f229fcd3fb44ab5e0e6"
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