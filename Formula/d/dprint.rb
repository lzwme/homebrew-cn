class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.52.0.tar.gz"
  sha256 "3f42e8e9134f62bf28837817ad6240e3465cd0af962f0298cfb189fba2437d3d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d480758d3519718f6ab458662e13b41ffd398effe04c9b6b635304dd1059d1a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dbc02ecbcd21d6b6c798efce051e4e765de54be943890c2c42e53587c75a596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f333cdd2726e3a70d6966dd488474dbe4eff4cfbec877acc00c5561986a40d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "487c876a9eba003690b3db3a42b3f15685baab5fb2945e9583b74114d5b16dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a1b674a8e871636fd2238ab993ef71c5bb99870487dd0df6aeec0fcbb09c26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07b24892015e26880785af2e9675366dcf353ea3fd29762ed5732ccc614154e"
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