class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.4-source.tar.gz"
  sha256 "8a57e9b78ea2c2312c91590fd5eabe1d246b5e98b585bc152100e24bf81252a1"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea28ca9c9a00ff84d6318eaeea4b795c6d22491a4baf952dbefefd49f4a90c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d832409f39eeb1feabf1b4de4fd284ff0c87e5ec3e9e51b86b3d8b3c546ba00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc74ffa5fb68a68b4b97b3465f341775804bb7d894e2afb47a36b53675b3ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13f53c30db03bf747e153a5b6adc378973896e40184ff7759fc6b92a1bf6d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e5450496ac951a9b2e9633897e57426999bd18f5712864ea7fe15dc9a6a5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323e31ca2408c45a1e0a5c303e4b038ff74faeed2ca65c024d36dd334be3a1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78581850357e05ccaced24f3ad932750b6ae318b8317c6574eabd62262762123"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end