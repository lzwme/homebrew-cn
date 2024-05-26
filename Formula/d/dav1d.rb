class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.4.2/dav1d-1.4.2.tar.bz2"
  sha256 "18d0c67421fac213b680a26856dd74ae7bb28b9ff59edd6f6580864d2b71d1ed"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4219a848496311958aab044a57dbc974bea071d3ab17750bf0fb4c3f41fb1fdc"
    sha256 cellar: :any,                 arm64_ventura:  "06a12d0131807ead15dc24a398067ce905164c0d76197a2ad9450958111f1295"
    sha256 cellar: :any,                 arm64_monterey: "c8f03ca1fd5c1bf3b3f04ada2078a5200aa0af4e048f13d4a4955d559be47eab"
    sha256 cellar: :any,                 sonoma:         "4e18a2fa0eab8ee6cc113867377a8a4d47ddff640dc35a03ddb3e72d06e73ae9"
    sha256 cellar: :any,                 ventura:        "d5244ae055270956fcfd7db7948e2f652ecc9c58234a1c7a14db537b5a3780be"
    sha256 cellar: :any,                 monterey:       "d8d72c1c1cd98c722f9c30010f863faa94142511bf5c00e18d634fd6a871efcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6706adc207a7dd2874d462fcdb9d0437758607372397dc7b1f1b34babcc99ad4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-00000000.ivf" do
      url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
      sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
    end

    testpath.install resource("homebrew-00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end