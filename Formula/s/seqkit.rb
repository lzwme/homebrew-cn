class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTAQ file manipulation in Golang"
  homepage "https:bioinf.shenwei.meseqkit"
  url "https:github.comshenwei356seqkitarchiverefstagsv2.7.0.tar.gz"
  sha256 "b5c723ffd4640659860fc70a71c218d8f53bea0eae571cecc98eff04c7291e02"
  license "MIT"
  head "https:github.comshenwei356seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "220332904e4a88963670a8735c24e3be0d3725fb6ec5c061952d3135b6193692"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a09c4f4ea47fc402958ff04c96174d21e5bc480ef30bcea50a58240e9a710ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1445b55643ef2e37de8892593c3eb53af8cae1bf7481ba8a595632812721a484"
    sha256 cellar: :any_skip_relocation, sonoma:         "a09ee8e2d45639f4b8c7017901c5a45a90121cd7b9a0ca6f03c1b6550c29ae18"
    sha256 cellar: :any_skip_relocation, ventura:        "e90d3620ddeb5e847f6c1d3d030a03c82a2a542f726c49aec42a1674107dc8b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b01e97e77b9be247f2a7c64a0b3ba9081553bb0d6af081c32fce8a5dd7590cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485c59a26fa5d09874aa047d946c2f0fe6f7cedb6fdea0a9e23781eaefb4222c"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https:raw.githubusercontent.comshenwei356seqkite37d70a7e0ca0e53d6dbd576bd70decac32aba64testsseqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".seqkit"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end