class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.0.8.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.0.8.tgz"
  sha256 "03bf008bc247ccf6a8e0448ba900f296619849cb7fb3b241c4200e56f1133896"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3edb09cbbdca16bbb06a5af45b39e15299b79689fe7e8c2e6968eb4534f2bb57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2390d4c1012feeb54e610bfa3ea2df3af62bf2310c7556497f7666032ab4f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b0b7007ca8ac2542d11ca32829b649c2509bd84ec288a6d339482baf6760b4"
    sha256 cellar: :any_skip_relocation, ventura:        "910dafae171727fc1af6b748b2492cda5bb60b5de491e734b14e02055db8659d"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9219ab5e8cef24d2ab57cd58d9a843bf8f2023de8b799927b1dcb16f8e71ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed223761dfaad24205ebfc18abce55c20d8c1ed1431cf312a724ad2c9214f13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b18d1f996b9939e6b924cf262e844353dd6674e36d3cea8235ad2265ed6f3d"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end