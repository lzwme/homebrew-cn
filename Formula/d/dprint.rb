class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.59.0.tar.gz"
  sha256 "7a242b2d7a57b17570e383aaaab170eca3b5cb1bf88b61e12b0724b3a6fe9a34"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c83a02e43ba63ffff5f238d99303a96210cd3dfca80f51088a536361efaccf8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cc3c669e53c6e9e1afd300aaaa0979b43708565a607e7deb628dea1db4c6273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a86131fa34a58f8d240ec7180b4c049c817b4f79e9c0c186d0ffce3f581f2e65"
    sha256 cellar: :any,                 arm64_linux:       "c358f6fbc55daa269e32bc175cde6828e10d2cf71760ecf9ae49e385a2acbd27"
    sha256 cellar: :any,                 x86_64_linux:      "44cd1027754fe80020a6565664ecbfd210227631740bf6353001d833a4c7c7ed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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