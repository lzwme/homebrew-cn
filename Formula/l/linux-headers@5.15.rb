class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.189.tar.gz"
  sha256 "45b7732e9e06229592ce997e78d01f62bf8a7ef689949649c452145fe26e93dd"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b6510a990d80605d11420282262fb87d3abc65aaa914d66e75b9db9546dde851"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8afd2b730c241505c10d30b35da46eb3a6db9160fff38e1da34f5a4e2cd673b1"
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