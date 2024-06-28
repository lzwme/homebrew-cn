class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comowasp-noirnoir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.16.1.tar.gz"
  sha256 "c6968a08fb088a636c856b6c256ad6c3facb6df64713648ac68d5d132170ce95"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "2e612535fc80df55436fe2ee12aaafe2d9b30ce1fb61a225f6b996f88bc8830f"
    sha256 arm64_ventura:  "7d432f1aa9ea9237203b613c12b7b1c3954f0576fbaa41aa20de780e8a96aaa9"
    sha256 arm64_monterey: "21a640cec6c9dd754469ee8039718d07a98674ebc0d15183c53e1f7bf11368a2"
    sha256 sonoma:         "8921344dbb277320723b92f89440cf654bf576961eabf914cc2a3ce399e59394"
    sha256 ventura:        "7db5e6f4723122f6abf135000b41e933537c78900d437bb1878d59076c9d8a20"
    sha256 monterey:       "4dee8b3e0dae2fb1639daf3d16ce7ce2892d5a02e8437a53cd4d557c72edbb12"
    sha256 x86_64_linux:   "e09e339d1decd5d7cbae23c9fb239ec68c9c4d1898fd9af805db3d04d9bfad66"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "binnoir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    system "git", "clone", "https:github.comowasp-noirnoir.git"
    output = shell_output("#{bin}noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end