class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://ghfast.top/https://github.com/Latias94/merman/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "423fd38280312c90bcb525ae214998497f935a3a8d3715d1b8bfc555084c076d"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "431c6d85111e33afd401fa64a03e8884d369ab3a483de26eb198dbdf4bbf7bb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e023702438e789cf4045c8fbd5d1850f07a319d63b678646cac97e4757b72b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e977e15660b4a736cebd13006fbc6c392704bbe8943793597f6992b9dd8f777c"
    sha256 cellar: :any,                 arm64_linux:       "117cc94a53ee82739c385c22e4cd7c017b8a40d28b2f75ca5ba01d98b514b6ab"
    sha256 cellar: :any,                 x86_64_linux:      "fbf8ad6ed44736d6220c58a07bf155a5a63f67e03d07c74001a41ee24234354e"
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