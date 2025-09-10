class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.192.tar.gz"
  sha256 "09fb7cf6acd1e7c1a3c5963856cca97035bd845879383cd56eee243732afebd6"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4ea9fe29f85301e0266a818bfcd3c6f75cddaad58422c3bb9d7c52bbdf4788de"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d519871ac0cc6b4724f82103060639eef1c062222f8b60ad3444a03ebb7a859"
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