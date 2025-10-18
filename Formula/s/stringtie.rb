class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://ghfast.top/https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "8fc429eb7437cb62cd95440a3e28529719cc72133592ce8e02f5cf249ce3142e"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c14e68b1673b69143178f89c9f32c17466bf2b5af7a40e6a90c8f5bed61d27c5"
    sha256 cellar: :any,                 arm64_sequoia: "1ac0cf98582d7ba1b1d00703941bf70209d9fc589c7b2b0fe87e638340543026"
    sha256 cellar: :any,                 arm64_sonoma:  "2a5c3b277611d4b6506d841a870fa39b3a607fbb07e0c6e85c79a1319cb3a79b"
    sha256 cellar: :any,                 sonoma:        "93ccbf7380a10bbb59bbef0ebd9a1d87d652009378912f6c107a913b37af7b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc194a5e8f17f784e39435e940849cab87e43316c2121df72211484af6c18fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997003f4c9ddf4bc5a6bc21e6102b890c248d5a8878e5c011aec37d5c3ed59a6"
  end

  depends_on "htslib"

  def install
    args = [
      "HTSLIB=#{Formula["htslib"].opt_lib}",
      "LIBS=-L#{Formula["htslib"].opt_lib} -lhts -lm",
    ]
    system "make", "release", *args
    bin.install "stringtie"
  end

  test do
    resource "homebrew-test" do
      url "https://github.com/gpertea/stringtie/raw/test_data/tests.tar.gz"
      sha256 "815a31b2664166faa59cdd25f0dc2da3d3dcb13e69ee644abb972a93d374ac10"
    end

    resource("homebrew-test").stage testpath
    assert_match version.to_s, shell_output("#{bin}/stringtie --version")
    system bin/"stringtie", "-o", "short_reads.out.gtf", "short_reads.bam"
    assert_path_exists "short_reads.out.gtf"
  end
end