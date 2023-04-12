class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.35.4.tar.gz"
  sha256 "26655a4c42858c4285d09ca0264201be60134e8a3cb6f2079595ea670951726a"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5a093d73b2c5961e0999cf0db3b945d16b08db1f64a8984de8769075786755a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb6ec35b097170245c77ebc0476d08a6fc520bffd9338efec4790f27855edb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98fc18a5fe6134e3a7b209c5a31a9f151969f815aa2da701965694b26b2877b8"
    sha256 cellar: :any_skip_relocation, ventura:        "bce6b485ec14746b151776c245a5f45b52c2c5a61285ca529af59458cc8511f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1a94e24a6dc2eb03d239b2b702805f775cb24bb97546ec0d6899357d2b2041b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b7cb5d908f8840085f3ff6a1ea0e20a74e05f7120d6a89c50441ec9aa0ad930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46feb7a51e078eb1d20dcbf513a28debdca899f663636bd7835ceded20f9185f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end