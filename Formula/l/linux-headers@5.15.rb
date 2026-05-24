class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.208.tar.gz"
  sha256 "a19888c8d061df74a5c897d0bc0e78f9ff0f69817ae67472a4dcdc3587fcc4d2"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "276e4fcb154b98901b25e4a8c24d574b380920f6da4be31e5fb3e66e89221bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53cf81e3aa516cc02242ccb3d56ebbf8efce586628ad8f18a8e8a1b565e8221d"
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