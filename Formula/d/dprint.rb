class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/refs/tags/0.43.0.tar.gz"
  sha256 "2e07d884074df696714289e11c41133f3f163eda9adb4a79db49903f3a2fb67a"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac4417d46e09ff27fa7e64ad6a43fd2383c132ffb5c02be1649a4f03ad519b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52305c3f3d94a7d1a72ac2ba3b2e480e13da1cedec4b779a04cafb7c870388cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa9fd3db4657c6b92fdecad9e901c4d0f83839d93e241617fe92f2cf76b62cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5908eb4ddd4f60a3ee3777f8186d50cee1a22c887a7c08a7a7dbc7ddab4a8abd"
    sha256 cellar: :any_skip_relocation, ventura:        "c67d61cb94660d172a141be171df61f6ad4ed215d20bb93327ce779e16c61807"
    sha256 cellar: :any_skip_relocation, monterey:       "05cff723a09cd31439c905faeeedd61538a19b712e71889789ba6b0b35ba7251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d649ebf75944b253666807c0d10be2d3a2e8176f2b2c84e59c981b2cd6bd4573"
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