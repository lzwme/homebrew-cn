class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.220.tar.gz"
  sha256 "71ab7732abebe565f133229871c4bee33c5b6d54279ef463c69cf980738ef8c8"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f6013b775ba4c8d72a0be9f805e1420df6a44321c37e52cc6d15703ef151d6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a1fe9168482cf2993af580689ada2c2478b06191d0f808f99f73bcfaf56aa346"
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