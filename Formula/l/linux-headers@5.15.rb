class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.219.tar.gz"
  sha256 "1f80cc61909fb7f331e6518f9749b853de0a41c711006b839ac6f52c7f3b429a"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "91e5668bdea5230b661571922add6de06f3bf8ebfd81bad9ba06cdc1da38cdd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b73c6f14c94ad01a7a37bfd6501f160d2bf434421a95b954bd9cf3edb4eef3d"
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