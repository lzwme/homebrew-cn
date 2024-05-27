class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.46.1.tar.gz"
  sha256 "652c878824f05d561149934f8f32c53957b6d77da7bfe2f08441e1caff381e9d"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30e8ef56eca3a209d166c2b6bf5c05edc13d821777a00d0a2c51110149c21544"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "165d771ff5793b7b27a516848cf630beb5d5412f997409ef05a2cf28947de671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96296017c6d1f33ead80656a813f1414a1c3f4c7375974a1295c2bacce584e61"
    sha256 cellar: :any_skip_relocation, sonoma:         "993bb12f451f76ffdf4f8f8883639436e2234236bb00cf550b557234e9120e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a73e4d7d9632548202e1511552f7cadaec85c1c6e984c3a1d56252085d7788"
    sha256 cellar: :any_skip_relocation, monterey:       "de066b1e3b3adbc50122f5a8bc655593882fe7a11829ac0f2157bc8b3b2e7e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7773ce4e8073297dbbd07ed0b46012ac000447730e804fbf7ab11fea8b0a133e"
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