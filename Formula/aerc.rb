class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.15.0.tar.gz"
  sha256 "dbeb41abc71d4469da9067d401146843732d9838972067d18f836729006ca033"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_ventura:  "cd1ecd4e3af857a01592816af51aa4be80aa99efdd8b4d41e5a1589c8ef4ccfc"
    sha256 arm64_monterey: "a7bc1d4423a6f458461c534c3b5831621310b1e8167e112701764e4c60292ed7"
    sha256 arm64_big_sur:  "e0a383384a62a8f87b7d043738068cf7d21b613f23ff803cee591ebd9256abdc"
    sha256 ventura:        "f28983e4bf0da88aa9ecf605550f2297f517026ed1b7c188aa560af24f54c977"
    sha256 monterey:       "b0d519f08fef83a02d2853676cb2d2f68cfea749407960ad5ed7e7a15755d052"
    sha256 big_sur:        "3e138185b168668287b90f63a745f74d99aa0dd4f9dde4ec416dddf06ab6a696"
    sha256 x86_64_linux:   "999deacf76a511a8689c5d87b32169d1f1bc6d0f7b018c1009d091a9fb9b006b"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end