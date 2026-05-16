class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.15/librist-v0.2.15.tar.gz"
  sha256 "6025d19b11b6ab57c5e8a00df68cbfc72ef83444afefd2bdcc81ce592884cb87"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "595ed1ce8182609029503f55ddb47f6be9778150c5241a49545073c459eac795"
    sha256 cellar: :any, arm64_sequoia: "e98357da7ded0831f62e7ab8cdee56a3e982b71eba8891cf85c897b506f5dbf4"
    sha256 cellar: :any, arm64_sonoma:  "0bef8f02970e42d789657f48dfcefee0c412d99e0acf38d7f929153e4a3827f5"
    sha256 cellar: :any, sonoma:        "ea80c5cdae9207d83233312fb441fa80dbbd2cc3651e44b78fc837f2c54bdb3f"
    sha256               arm64_linux:   "8a9c190e59ebd3927c14bf8465513992fe93e8d2be7d56238954f850fc10a74a"
    sha256               x86_64_linux:  "63ddb30fee65c8bb4ce6fe1eeadde01753fcb803f60c056eff0c554a20463be7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls@3"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end