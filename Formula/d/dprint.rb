class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/refs/tags/0.42.5.tar.gz"
  sha256 "3843644d142efb61222d7fb9faaab2776f350bc3243830c7f82bcf609ef7bfb9"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c41cb24ecf4f6dd8ea8ac785fc40d9dae933ef8f9791fdb558b5ed8c4845c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2142d908eda0630c91e3c60487c128dd34b4c36c8d93bd129068a6613fe693b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a436f6540fc4a45e0d6420c04e954c794736409f189eeef86b5bcbb1d4942a7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ffc79ac27ce3d061cd7c3445b023125ff261e3522c6563381e189156b89eb62"
    sha256 cellar: :any_skip_relocation, ventura:        "bbde9804a8c57a9bbdb89ce4ab858650629ddef3818698a822286719fd401bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b7d3320e0c7d451dced93d8e4bbfe1ccc89da003a31891240beecd1bdb6ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a0506c086c366a558efa6e82b38d08ad2838a6df779d579e3a534085aeb1ef"
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