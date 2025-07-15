class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://ghfast.top/https://github.com/rfjakob/gocryptfs/releases/download/v2.6.0/gocryptfs_v2.6.0_src-deps.tar.gz"
  sha256 "b3848626b90d0fe87aaf81cc6ef0983089d1a93653f30e7d9b89c7c6e872a4f5"
  license "MIT"
  head "https://github.com/rfjakob/gocryptfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b3f8cd47fb9723f23a269891234dba134f2edb3d20d60e7bd4062f3a277573e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "309522acde8449ddc3e83e4316d81a3afcd2118dd88f1c5f6a8e3497c87a96ac"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_path_exists testpath/"encdir/gocryptfs.conf"
  end
end