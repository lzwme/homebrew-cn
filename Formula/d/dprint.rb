class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/refs/tags/0.43.1.tar.gz"
  sha256 "4b2ce0994967acb67936cfd681b4b2852a379b0e7bcd422f8aeee1eb6179b21b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42b7c22a53f2ab21cff7327d8b33b8fbed88666dcb56504911fc41c2c32e1a73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17869a9e29b04e7d15c3a870309c52062739e01a43cde5f09306820878914af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e52b17c03d254f89cdaaeaeb7bc5064cb93ed2dfab404ef7f6c8d36c74140d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f32b102127942251a909b4ad417ae288902515c67ff827125ee72cbd27398ff6"
    sha256 cellar: :any_skip_relocation, ventura:        "afc21b77a2bd86dd19c5dfaaa48ba792180a9597301ab0ec469a19e0d722994d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2c67f18db6b503d6e3d1aaa835616aeade94225b9a419724ce85a59d7be9b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b24721f3529c9e69f7293a239fb05f3083fc07ce9dfb54b1c67802859e6cca"
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