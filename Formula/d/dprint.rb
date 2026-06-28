class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.55.0.tar.gz"
  sha256 "40b9f7235ef3c67dfbaef56f3dc802572dbdc70f1aa9e585cebaaab53b84064e"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc0abd4923ad22755b08a4d7d7c7fe36cffa93ffdfe33b3f1dffe53566068dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20430fe589bba5a3e9cb303942684635516aa06a3089e4676ceb1efec5eb30a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5fc81c290b6e096e5fcb6b0cb097a344bb8a9e7d17e6d06853afb607d8e19e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7290ffb6d67157fc0717a782e8791aec60e679112933b53300fc597b1a4db128"
    sha256 cellar: :any,                 arm64_linux:   "fb4ac75d1dabc9faeccd7c06771b442960c057c63d7fca761db18b74dd35e41e"
    sha256 cellar: :any,                 x86_64_linux:  "0bfee30aaf4c2ec9ee2cbf424cc4b0d9f7bdb0fdf1777123962a9c0ed6ee4282"
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