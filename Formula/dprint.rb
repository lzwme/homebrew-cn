class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.38.1.tar.gz"
  sha256 "a3af8806536480e6e8bc407d6e10032cef942776218ca37d8ac467b05e89679c"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad6c2c56129517dd023dcd9f79c150cd24b25da7508b5f7904d3b68681191ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abf7c96eedc4750bc66ec7589d2a53407cfbdff01b667e791c41c150d6e90512"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d3764fce76e6f51bdf087bf1f5830b4e0ca2897732d93306c551fa9dceffcc"
    sha256 cellar: :any_skip_relocation, ventura:        "9da6309ad5117b3b5f54a2027c44d9f68fee8ba28a4c5d5aebb9e495b4e947ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f909f8ba3095bfb61590d4ac7659a39523c57dabb598a002f83946fdc1975e55"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f51b9bc7dd1b67c0471fca8c08cf1b628a2016691237610265574626c0d6678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d1d67dc2c4e936035fad1039f5d645ac30fc71e0c72b59aa4ba2abe4defc51"
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