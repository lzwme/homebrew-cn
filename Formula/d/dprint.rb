class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.57.0.tar.gz"
  sha256 "57fe52b3d6f51b04d7108b0aba72a0c07ebd53db020ed04d5b10364fd5c19506"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6acf148e7c50b5d9bc2be312a2366b558190109d94a5dbf662842187921fdbbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c741387a10f80f39dc927abfd9de6cdb0ed489c04c3739677e876abf512e12c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60aa22fed858057858fbc7f642b81a30f8a3bb7d054ac71ff6d7157189c91c8c"
    sha256 cellar: :any,                 arm64_linux:   "918f1685d4210b1daf4b1a0a4cc95b4522d844372062e7517a7abe769188c566"
    sha256 cellar: :any,                 x86_64_linux:  "47f4b4dd7dfbdf94b12cb492c7c96b5341e64db1350ad7d87847e6beaf18d381"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end