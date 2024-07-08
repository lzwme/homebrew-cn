class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.47.1.tar.gz"
  sha256 "ff03744dab64166202ede1a55962ec4452dcf6e0e49f04f0957791b256449677"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "712f9320c9fa9dc9605ff0ccdfbf35fe83f0e5efd49fd2bf227c117af2d0161f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ade90d4c7f01d13b6c2c0f9f77d84b64c61566e515edb9e261c59f62e82fb07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e398aa9d0c1d99d6b9f35cb2399e5fe76091682ad0c86d0c1aa8ec9aca07f571"
    sha256 cellar: :any_skip_relocation, sonoma:         "76e17f37010442709d4c8a44dfdeea4b68677f0004ff31c9f7d2fdb1bf40553e"
    sha256 cellar: :any_skip_relocation, ventura:        "98aafc8ca6ae06fea0ba454fb920461290108e909793b9b5fe34ada962753881"
    sha256 cellar: :any_skip_relocation, monterey:       "d834559b248dcdc06816f4a02843b864309b8ab6557bcbddbd098564a8157d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba30ff6bf39a6d62ae58a2b41eab2251a4276221436917d79b077b3207bb9bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesdprint")
  end

  test do
    (testpath"dprint.json").write <<~EOS
      {
        "$schema": "https:dprint.devschemasv0.json",
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
        "includes": ["***.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**node_modules",
          "***-lock.json",
          "**target"
        ],
        "plugins": [
          "https:plugins.dprint.devtypescript-0.44.1.wasm",
          "https:plugins.dprint.devjson-0.7.2.wasm",
          "https:plugins.dprint.devmarkdown-0.4.3.wasm",
          "https:plugins.dprint.devrustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath"test.js").write("const arr = [1,2];")
    system bin"dprint", "fmt", testpath"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}dprint --version")
  end
end