class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.25.tar.gz"
  sha256 "162495aabb1cb842186cb224995e3d5f60a9f527a49ccbd8212383cc72b7c36c"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3aedb889fb5c34796808c55b1e947238e41b751d3a1b9f71b20910502e62504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29daf6ddd5fb54358109b5d5d976e5b0a0bfde8a4ba96990b5b656794c0f54ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f91bbe641cf07ce61a2dfb6a0110f04f82494fc72bc327a1e2a99f764ae7c2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b900e477a01d4850834d587d336bb560963fecc173fdca6659f27a70b02669"
    sha256 cellar: :any_skip_relocation, ventura:       "53bcb7077797b93c0feec686676cfb00737617675e9fcae19b5ba83fdad4fafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25755c20fce6dfd4be0fe76c047d5c68111fcbcbffd0415206b79085f659e59"
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