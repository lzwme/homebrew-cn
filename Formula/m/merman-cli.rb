class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://ghfast.top/https://github.com/Latias94/merman/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "900fcb1c947e886ba501f5b5663f89455724fe16c3623fa5bb30b116bec7e33a"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7654d4adc8879c1a718c0e424fa1388f7330a8a5089e8b03d230d867264984a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7820c0e287f61c09c439dda78c87cbec9a5ebdf5276681d83791d6d3c6b3e599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0cfce115cf418d3650919e601d415a07d2dfaf4c9a2c134f6988e00552e7ccf"
    sha256 cellar: :any,                 arm64_linux:       "b1c920887790f7a290ea8788d78f4fef17fda33fa1a55dc9338222f9c25aeffc"
    sha256 cellar: :any,                 x86_64_linux:      "98660b7ca55daa771d9be5afa878ac3b150e26ca1110144704a5d9373fc93c10"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")

    generate_completions_from_executable(bin/"merman-cli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
    man1.install Dir["crates/merman-cli/assets/man/*.1"]
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg --output - #{testdata}")
  end
end