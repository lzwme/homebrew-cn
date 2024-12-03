class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.7.tar.gz"
  sha256 "6976a789ee1bbcfdc47732015b60589c1d0408892252dd7cbb44f43363a2f33a"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907e9f114fe5c31eba1c9dbbc0ba5fe14eaf882639397819082765314cd7d763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cbb4485f318aafba34c7822ee28736776ecddefc9817464082a5ddbe10d697a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "098c40aaaf9cadc64ce87f641fc93bbc34043af3199089b2ab8c0a9fb9d0ec7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3eb76a12406cf4fd0f4af0dd0f4a61475c5dc9acdb451a5f27cdbf69be6bd0"
    sha256 cellar: :any_skip_relocation, ventura:       "25fe871cbff3253c0f1928ad360399547175ac787245787cb1b35528d761356f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2325f0ff216530b9f4d5f027666a002ee213ffc3954930b02038b2c6531215cd"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end