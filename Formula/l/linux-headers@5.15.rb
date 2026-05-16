class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.207.tar.gz"
  sha256 "5aaa1ed1becf43ac415aac94f15cd6092fcbc81bce5faa793b91984357d5aff2"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a80c34d499a93e23540edf20e25391e222c6cc5d7c76fc0a3616108bbedd453a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c16749fb24319b1ca80979bf99708e9f865a3d9a7004517eb7c6ea098fc88f52"
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