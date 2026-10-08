class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.61.1.tar.gz"
  sha256 "31147adad81f48b29a4a729e16ea980807028c528f6fe36261f62fd0d917c306"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "039ff31ceddc8872087ef726373397a800f7e4f815828f5c587fe25cc709dc14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b62cf40aad5454baae1f19ae2ce2327e7290eb397e858ce7b5f22241c03e6eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd2c1ae07907e3f8af4dc46bc0406ad6d184fa669ffaa71637f596be70ac19dd"
    sha256 cellar: :any,                 arm64_linux:       "68809b4c35423ad7451e0248e4c79b29bc841873c6563c1b4f0115f3640d97ff"
    sha256 cellar: :any,                 x86_64_linux:      "578f86196b7c3013f702931c277a728b38128280c25d0746d9ef835e21e32179"
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