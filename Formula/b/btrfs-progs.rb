class BtrfsProgs < Formula
  desc "Userspace utilities to manage btrfs filesystems"
  homepage "https://btrfs.wiki.kernel.org/index.php/Main_Page"
  url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v6.5.tar.xz"
  sha256 "8f507a0cdf6a8b372d862dbe4943fe84c66dcb2088e3cfde2cfb3b176eac1c1c"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.1-or-later", # libbtrfsutil
  ]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/"
    regex(/href=.*?btrfs-progs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94a6ea73fc957a5683dcacbdaef77e76005351d573d92ac89cc19f156f261341"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "e2fsprogs"
  depends_on :linux
  depends_on "lzo"
  depends_on "systemd" # for libudev
  depends_on "util-linux"
  depends_on "zlib"
  depends_on "zstd"

  def python3
    which("python3.11")
  end

  def install
    system "./configure", "--disable-python", *std_configure_args
    # Override `udevdir` since Homebrew's `pkg-config udev --variable=udevdir` output
    # is #{Formula["systemd"].lib}/udev. This path is used to install udev rules.
    system "make", "install", "V=1", "udevdir=#{lib}/udev"
    bash_completion.install "btrfs-completion" => "btrfs"

    # We don't use the make target `install_python` due to Homebrew's prefix scheme patch
    cd "libbtrfsutil/python" do
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    device = testpath/"test.img"
    system "truncate", "-s", "128M", device

    output = shell_output("#{bin}/mkfs.btrfs #{device}")
    assert_match(/Filesystem size:\s*128\.00MiB/, output)
    output = shell_output("#{bin}/btrfs filesystem show #{device}")
    assert_match "Total devices 1 FS bytes used 144.00KiB", output

    system python3, "-c", "import btrfsutil"
  end
end