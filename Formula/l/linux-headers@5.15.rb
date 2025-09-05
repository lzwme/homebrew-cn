class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.191.tar.gz"
  sha256 "fa3e12262d9d0ce204f21076d6b078823f9d4facc553d29165b6d438d4a36547"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cf38716f5b05ef68606b84ab195529517d1ed91bf90b1650618183658c541269"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1918286dc2bc2b858919d44914f9238ed99ae9e704aacbb6cd5f1b4e745d6fbc"
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