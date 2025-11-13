class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://ghfast.top/https://github.com/alerque/decasify/releases/download/v0.10.2/decasify-0.10.2.tar.zst"
  sha256 "8a9d3f8d4a1eb4824b8021b5d616ad6a69d45f481e6bd25b175386d71ab04229"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e87106f58cbf7b858e8ab0a1727e20d7935b7596a67b0f741bd5a1ec5ba874c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad54e75038e40143ee8e32afc8251ce179fae7abfa576e8b479d0139cf65edbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5293fc1fed40589ab6f7ddd314dc0eed433701c15af60251100dea5c4a653c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "47493cf2bd6e7b3648b59ae7ce5d59ae0876abc468158586ef333cf324bf3870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba0998b43f8866141072e77c681cd0b406123f60f0a847d64ac2e262e31a7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d1330999392eafc7f88b97997d7a54ba4fb5145329b171c43421cec06ae918"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end