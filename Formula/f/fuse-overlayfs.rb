class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https:github.comcontainersfuse-overlayfs"
  url "https:github.comcontainersfuse-overlayfsarchiverefstagsv1.13.tar.gz"
  sha256 "96d10344921d5796bcba7a38580ae14a53c4e60399bb90b238ac5a10b3bb65b2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "787d0b0e332ae57ce25d8eaa84332c5122117291a0756f182a97ecbc125eb8f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "-fis"
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    mkdir "lowerdira"
    mkdir "lowerdirb"
    mkdir "up"
    mkdir "workdir"
    mkdir "merged"
    test_cmd = "fuse-overlayfs -o lowerdir=lowerdira:lowerdirb,upperdir=up,workdir=workdir merged 2>&1"
    output = shell_output(test_cmd, 1)
    assert_match "fuse: device not found, try 'modprobe fuse' first", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end