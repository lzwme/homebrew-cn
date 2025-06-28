class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.186.tar.gz"
  sha256 "c92540f079db6101d8223f4416ce3e02494d4c6df3fdcfdca1ecca7da3a88d00"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b76c72d3ea544c8944bca37a7e984db053dd4d9a82ea6cbe973a884476bd306c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f55faa1ca3c9983af2dcbc42b8e6a6737109ae62f2fe6a6750f6a2af238c8d8"
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