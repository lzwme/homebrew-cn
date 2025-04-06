class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https:nuetzlich.netgocryptfs"
  url "https:github.comrfjakobgocryptfsreleasesdownloadv2.5.3gocryptfs_v2.5.3_src-deps.tar.gz"
  sha256 "4b6d874b5383be5ed33d7ef7a5a6152d2b6a5d1965215a426ec855c043138ee2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26a541331bfa8f7ba51f14f07c97efaec13171cc88515e217d559eafdccd132d"
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