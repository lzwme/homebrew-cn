class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://ghfast.top/https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "8a6df5044d5daf26d2e728f74b4d0b241ae38e5c9bc76b4513e68b9b60d7cf78"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a93b89acab8fbd217448566870e441543a2196f2a21587da14f98aa4e76bd84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bef53c8395475decf053cef4ca93e7312635b6ca382f724449abf7bc3935428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b0689c2e1c1a146be3c1c6b5fc04a03e197d2210609559ea90c460536c0247"
    sha256 cellar: :any_skip_relocation, sonoma:        "004965e418d46e0812453bf920e536140b300284dfc5cac983ec70abee2b2625"
    sha256 cellar: :any,                 arm64_linux:   "ae23e8f7c68e830a032dc97f4a7d5b34816a13493e9a99117a93e10620b5d339"
    sha256 cellar: :any,                 x86_64_linux:  "bb73abcb100bd39d67ee0479ecef6e057c07ab8406aab90e548f7f3bf191db11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cuttlefish-rs-cli")
  end

  test do
    seq = "ACGTTGCAATCGGATCCTAGGCATTACGGTTACCGATTCAGGCTAAGTCCATGGCATCAGT"

    (testpath/"ref.fa").write <<~FASTA
      >test
      #{seq}
    FASTA

    system bin/"cuttlefish", "build", "--ref", "--seq", "ref.fa",
           "-k", "31", "-t", "1", "-w", testpath/"work", "-o", testpath/"graph"

    unitigs = (testpath/"graph.fa").read.lines.grep_v(/^>/).map(&:chomp)
    assert_equal 1, unitigs.length
    assert_equal seq.length, unitigs.first.length

    assert_match version.to_s, shell_output("#{bin}/cuttlefish version")
  end
end