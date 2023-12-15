class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://ghproxy.com/https://github.com/containers/conmon/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "15a41e78f5e86dba429cc78ef4836f44ba927b6c69f1cd1721118a08ca0fd1f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7fcc3f69caa7f49d19e6b7a1ded32faa1ed8124baa0ffb360feb0d7b82c98071"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "make", "install", "PREFIX=#{prefix}", "LIBEXECDIR=#{libexec}"
  end

  test do
    assert_match "conmon: Container ID not provided. Use --cid", shell_output("#{bin}/conmon 2>&1", 1)
  end
end