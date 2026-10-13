class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://ghfast.top/https://github.com/Latias94/merman/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b185e0c25e3ac24c6ef0d26846a838a72e1612d3a375aa117c0ab1fdf28182fd"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b75b264a6249df640a0482645b146c97ca4df357e31203723f9c5c15b8d1ca9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ebf24752f9cd6ea0fe34910b7a056b1f17b8008dfe098a7eb2065470fb0cd8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "032e9d1b02eba6aafe03727c91cbfc996facdc10e940936360ab79f56a5338fb"
    sha256 cellar: :any,                 arm64_linux:       "631378e1b951eed2b0874cd051e578e0c4a13476cad20733c860ea4ea260df4a"
    sha256 cellar: :any,                 x86_64_linux:      "661b8923be476e0945759005295f057dad39286b89f1a7cafb2c6ecc407d3a93"
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