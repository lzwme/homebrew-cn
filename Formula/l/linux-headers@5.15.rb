class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.213.tar.gz"
  sha256 "11726e81114b6cd50399f1d2e189856c7359439ee12ce7fcfa6f77267b8d1e3c"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bdf5814dfb2f4d14fdf5d2e66b4e3fb7a256a75a3bc49c5735f1052b748e6736"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "160466d3ed01ae6d10fc3137edfceb41398ed2263e50c6037faa9be9976804b8"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end