class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.182.tar.gz"
  sha256 "eb4fe85945691cb705bac0e58564b8991e3ef7707eb0c1bf60def62f879d5556"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c148928c9cb84159a5f35fbb8b980a79684e1926e12eabb04d914b8ab4dd1b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33f742cffed587c14dcca8cc34f4993c5bb707c39356ff53612a0f0891264159"
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