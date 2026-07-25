class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.212.tar.gz"
  sha256 "27aa53f0a605389d6fe6f36b23d3b4d4f661392303f3713c85cf0cf17b9099c5"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9f2ad1933cdd6009a26689cab3d0a129cc6d1cb0b5fcd3f0a3daac4d2f1c1207"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63b1c0a15c8d453e011fb9cdb0449cb421af619a450864731f52e11430f2ff9b"
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