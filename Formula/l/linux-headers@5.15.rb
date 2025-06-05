class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.185.tar.gz"
  sha256 "07325ebf078253e66afe046326c87631163247b178cc92cbc4bfcc08f224dd8f"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6b35ae4848cc486655dfd243e06d040046ddb52baf0f72afd8666f170afdb778"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c40a7b6f99b2bec60a6a7ccf54fee66bdac11a8b46aca61769b8c22ef6202e8e"
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