class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.215.tar.gz"
  sha256 "91ca36a9f10e7bfa8e763c11cbda7ca42eadedd24df23fa7cbe834e6d38bef3a"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "30909de4488287b20d3e2ceb1a6b55d74ad1ccca4d37837607bb67f44c2f332e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7150495674b237102d8195e442ce1c88487c2238fd1fb39b17a30d33f0ef550d"
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