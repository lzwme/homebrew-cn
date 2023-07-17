class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://ghproxy.com/https://github.com/shenwei356/seqkit/archive/v2.5.0.tar.gz"
  sha256 "e3bcbfc25cae8f2a50ff3cc3aad96b3ab06d19549b6311e26547d4db2f28b50d"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eacda5a3ceee7133b8166c49034b9988be5a69c29e10e707c4768ab59469a865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eacda5a3ceee7133b8166c49034b9988be5a69c29e10e707c4768ab59469a865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eacda5a3ceee7133b8166c49034b9988be5a69c29e10e707c4768ab59469a865"
    sha256 cellar: :any_skip_relocation, ventura:        "436d7d075821b1c2ff19491cf514173fb2ccc19d4f1d1b3f6b754b22830dea16"
    sha256 cellar: :any_skip_relocation, monterey:       "436d7d075821b1c2ff19491cf514173fb2ccc19d4f1d1b3f6b754b22830dea16"
    sha256 cellar: :any_skip_relocation, big_sur:        "436d7d075821b1c2ff19491cf514173fb2ccc19d4f1d1b3f6b754b22830dea16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b76e4872cc908ccdf1a90e93fbf39a2bab03f34052bd40e5638d63e6c7904d6"
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