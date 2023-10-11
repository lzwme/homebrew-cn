class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.1.5.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.5.1.5.tgz"
  sha256 "daaedaa054f582fbf8a44ca141c19ecdb7ad3bf66e9d844682efc5b954352ecb"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d59fe9617b33913e2087fb955f5bb5f4789a989707d71546d368abb49d0fa06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c8cbdd071913ca33a93803530a75f54b182df3fb9b6de98dfde8919bdc3d5fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed755d3bd119cd9f7ad856a65c1f9a0e4fb8b417e50b4eb3d5051cbb6f9fd604"
    sha256 cellar: :any_skip_relocation, sonoma:         "297e321f4e2076c8d79809e39bbd1308e976e514e5f8539615003d9e9557ddef"
    sha256 cellar: :any_skip_relocation, ventura:        "267d3202b9fbfff89886bd0ed33093fa1a9492b63adf0a9e41db9553e452a386"
    sha256 cellar: :any_skip_relocation, monterey:       "e9c2180411118792eec55d806293f56465fb8d9636496936b45ee12cfa12096f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564bebe354d801f6e488fbc8115b9f6b7afa400f0a310a5196ca53b4814e8590"
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