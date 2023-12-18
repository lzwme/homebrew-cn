class Gffread < Formula
  desc "GFFGTF format conversions, region filtering, FASTA sequence extraction"
  homepage "https:github.comgperteagffread"
  url "https:github.comgperteagffreadreleasesdownloadv0.12.7gffread-0.12.7.tar.gz"
  sha256 "bfde1c857495e578f5b3af3c007a9aa40593e69450eafcc6a42c3e8ef08ed1f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62b090464eb1b0f2d1f0708e301cf4497a67782b96db9762c4a2eed1debfea73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65ddd7c7737f4ddfc2205aebb8be9e15efcbf543da71e76bb1c16b0cb6354913"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d4134d3c271a6f558ebee697ac59ee253c5df70aeaa22a58b28f1f23faa6e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9edeb2e17155f0d1bcc178fe53991d9a1e98a8db5e5091fee916eb194f9be0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c0b8963e2c47669ab50268bef64d09b89af8d6472a37de6c34c184f5e0f3a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e69ada91d38745bcd11fa7156ee50154ddca975b5b60e914c007d299708837"
    sha256 cellar: :any_skip_relocation, monterey:       "6c91305b71b24859d2dc2974fd4ccc0b8deca23457d652cbc7feaf96bfee6275"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe67ffbdac10132a2177190fea3d275b780e35baa58d44bdcc64b9f632c0484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0786b5ced3ce7d42b8f02a3898c6e22b7c7e56ebcb779d987909a62ac0200563"
  end

  def install
    system "make", "release"
    bin.install "gffread"
  end

  test do
    resource "test_gtf" do
      url "https:raw.githubusercontent.comgperteagffread4959f6bexamplesoutputannotation.gtf"
      sha256 "f8dcf147dd451e994cebfe054e120ecbf19fd40f99ae9e9865a312097c228741"
    end
    testpath.install resource("test_gtf")
    system bin"gffread", "-E", testpath"annotation.gtf", "-o", "ann_simple.gff"
    assert_match "##gff-version 3", (testpath"ann_simple.gff").read

    assert_match version.to_s, shell_output("#{bin}gffread --version")
  end
end