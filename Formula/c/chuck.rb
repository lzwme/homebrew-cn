class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https:chuck.cs.princeton.edu"
  url "https:chuck.cs.princeton.edureleasefileschuck-1.5.3.0.tgz"
  mirror "https:chuck.stanford.edureleasefileschuck-1.5.3.0.tgz"
  sha256 "5f2f0812dd68e0d2f0965128a486389049533f38149dee76f9f3df56581b60a4"
  license "GPL-2.0-or-later"
  head "https:github.comccrmachuck.git", branch: "main"

  livecheck do
    url "https:chuck.cs.princeton.edureleasefiles"
    regex(href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a60f15cc08b7eb7d2d593a5b79a58a67086f26efd6e7872ec8e0d74bdbbf8755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626e53ed38bfcbdbaf9bfaa0e5454a63883a31ef0b5cbef40ec2aa02c3f0af6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a12d87dc5755f49c8ff6cc12c7b4aca4c73a3222aae12555396161b83e863f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db5d669bb1bda8308db5db5e0ed07d3847964f360ae5159eb7025286c889c79"
    sha256 cellar: :any_skip_relocation, ventura:       "959dca43eb059f231c6e39551ede3402056d11c1a46c9bfd0d17bc94f6c6f68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5a5d4fb103fa994d936afaf47bdaebbbdc0f39b7cc6c3336ed22c20aaa2199a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "srcchuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}chuck --probe 2>&1")
  end
end