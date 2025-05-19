class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.183.tar.gz"
  sha256 "34852edeea2d9e40fbd6596c9dffbcf0fbe43d95e45360fb7ce46c3a0942863e"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "72506c744b8aaa5c5d8479bf339be7384ed7e375a3de7dc50574479205057e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5f9923f442e3c738e0c0c29ee948fb754b83e6bc2119a4cea9e2b8c7b56cd8da"
  end

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