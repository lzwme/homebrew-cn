class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.39.1.tar.gz"
  sha256 "0130ae9997aaf0c354327f720a5052344176bf427dd81431493592e8aacf55ad"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23205a0891417be99606db26e4e6a313c6ca74544bbcfb6da585f9c6fc3de933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "386fe0df382bbb7954d8e3199a44dc8251b04219f4eefdeb770ce2ae5eaaeb91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc1d9d22904ba02b53cc1bba61c96eea064f5f25705b8c6374e3e1d71043080"
    sha256 cellar: :any_skip_relocation, ventura:        "efc8ca2feb354813ac1898eab5b247cfd8d1c89203c2bb91ef1fd4b8481b207d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c919fc15fd81e8a8694ad2681b62b023e39c1bff0246c01357b7f199ab5e14c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f20b5e9d016fc28f361a1e30d68979a35b9c4f952fc8d17c1999c81eb6e97f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b2e067e65f7e17e48b8f15b59483d18d6e0f97efc74a2c922139b733a50589"
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