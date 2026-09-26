class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://ghfast.top/https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "dbe3fff5aebf72bfee2fc0f3f81fc2ec4ce9e599f52f3e9f3485cc8931679a7d"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2e3b7b238f259f34e01cb7c59bdf2ebe94c8223c4029c05376364a19678caa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "098b1b3c07bb65a6b1a252a8fdb3a7ebd25617b7dab742e8d84800bf1f1a4383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d91db1c5e4f45ff745cb7b4ce4ea1124471dad433581e2824f8d7bcae9fef570"
    sha256 cellar: :any,                 arm64_linux:       "f7e725f1249eb7f48d01c3ae472a9d370ee6836ae664c6072253d4136b244ab8"
    sha256 cellar: :any,                 x86_64_linux:      "b44ce51c38cdd3419400dba7b003efdb4d5d4eb11fc9bdce3d1bd39abdb249c6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

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