class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-31.tar.xz"
  sha256 "f5a6949043cc72c001b728d8c218609c5a15f3c33d75614b78c79418fcf00d80"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98443a2d0e7fc9328c79d003c86ea00daf584e1d81e3b686f19bcab3dc120b08"
  end

  depends_on :linux

  def install
    system "./configure", "--with-bashcompletiondir=#{bash_completion}",
      *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    bin.install_symlink "kmod" => "depmod"
    bin.install_symlink "kmod" => "lsmod"
    bin.install_symlink "kmod" => "modinfo"
    bin.install_symlink "kmod" => "insmod"
    bin.install_symlink "kmod" => "modprobe"
    bin.install_symlink "kmod" => "rmmod"
  end

  test do
    system "#{bin}/kmod", "help"
    assert_match "Module", shell_output("#{bin}/kmod list")
  end
end