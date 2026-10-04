class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.222.tar.gz"
  sha256 "d6f8480792a6882f8ce7d786ac7e4e43b6bf352e81c912cb0e020f781780d4db"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1d8173520fb3a8656b9a3070cfffaa634c71df817b284b95487b2cbe83d794cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13095138ca906dd8fa856d6f53c62f30b93da1dcb0feb69c797de97dedc7ac12"
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