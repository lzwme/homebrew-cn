class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.190.tar.gz"
  sha256 "27b0e54b70a426058f93b19f79bd096894763488ab2c8a0ae84d528ed8aba588"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ba391c38106ccb69a5eee79d2db0d76a28509d8f2e9013f27f497c5f18a7111e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e8040d069ef2dc69dd1434b0c4a88865f066cc8d200fe1d1b25e2d0c2dea0aa"
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