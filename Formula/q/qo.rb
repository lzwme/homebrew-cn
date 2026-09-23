class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://ghfast.top/https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8034b154c8388d719cb7cd012c6d5c457250150aa2e70877a0a10ad3a0696ec0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c924cba56b0ed933047f1b31880cf6aedc90566417b195811fab461063a5889e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c924cba56b0ed933047f1b31880cf6aedc90566417b195811fab461063a5889e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c924cba56b0ed933047f1b31880cf6aedc90566417b195811fab461063a5889e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c214f10b10f071e22dd9e1e1c2da167a3dbf678aeda606ca20a72c49c1f0bc0"
    sha256 cellar: :any,                 x86_64_linux:      "1345653b4db3807ae0c84e179226ee6ca297ffe70f2d41a4ed4fa50f8bfd65c9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/qo"
  end

  test do
    input = <<~CSV
      id,name,age,city
      1,Alice,30,Tokyo
      2,Bob,25,Osaka
      3,Carol,35,Kyoto
    CSV
    sql = "SELECT name FROM tmp WHERE city = 'Tokyo'"
    assert_match '"name": "Alice"', pipe_output("#{bin}/qo -i csv -q \"#{sql}\"", input)
  end
end