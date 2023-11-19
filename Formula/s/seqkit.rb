class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://ghproxy.com/https://github.com/shenwei356/seqkit/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "d88249bd3b630c908ebd308abaa9cd7acb7a781c12bab877d3daaab56f43c443"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66b9a869856e4cfd7bbfa54469af7970ff7fa9c660baee8b9cb298f5145440b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05adf94ea7227759df1f6f0b2e609a476ea824c25be457a973b0f1e513e13140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7bd29bf06d5c1cb0124d5cad93e317744c89ec82c78108ccc4f4527b90d9e8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6eef4cad89dd05d0825c4caf102b78988b4b00d8234a1cf27713bfb2cb072732"
    sha256 cellar: :any_skip_relocation, ventura:        "cace02bd16a83daef89de24f9d6f3fb2f414c4da561cc7de39fab24014161478"
    sha256 cellar: :any_skip_relocation, monterey:       "751bc0deecac6c8fca6857c4302905c87bbdd0f9c68035ab14c39af33adc01ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "203e13b48fb1457a673cb0a689a34810a1d029c06d557a24bee9ddd5ab3b94a2"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end