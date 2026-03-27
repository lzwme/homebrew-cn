class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.53.1.tar.gz"
  sha256 "a9c0dc171ccca7f2dc397613b51067da4e47f5be070c7a48027111930a793dcc"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f35e339e360c1a3d0bf9f4fc01b5bbf3f31a58701918244f2e05c91fc450b9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d43c9f0ee9fd4ca64433a0904d4dd13b7792fde6fb98639254bd9fb9f4525fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d67419d88699438d18fb3106dfbe8588aeaf4fc9c6ba2ccdabda7e76dc6846d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce049a15d687aee23daae4232b7ceb26ae8e66ff3a34368a1ff56765d8afadcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b2659cd7350906b69d237e1d198af12c41a55fe498e8b3254bb6488590cfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c163a17ef4dfa63b11f0fa313b23f84afa786c1449af51c7a4898968e6940f"
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