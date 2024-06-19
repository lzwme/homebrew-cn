class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.46.3.tar.gz"
  sha256 "3eb92d7f47c90065879abedf661e6008258eed9b081ddecf083678048da2482e"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60abad4d497803240bd754ccb0deac798e9196524760515a5582df2bbc30a5ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e716ac16033fdd5aa0aed0c4af8a1fb260476ebeb96449ab0bfad08406bf55a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0104dfc8c7201d4506df93da20a6e0bebd4ff15612923152f5955cea6196255a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b4afbf61200815accd402cc842d34b3c5a96efa7e3701140498c675ae2cd426"
    sha256 cellar: :any_skip_relocation, ventura:        "823e9bc1cccfafef855e73e09fc00150f835c6ec7c833e8342db38dc53133cac"
    sha256 cellar: :any_skip_relocation, monterey:       "25040babb9c02124e5f135b3c6d0a3cfe8d43bf06e717f36f1e806d0f27abdad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e91c71ac11e31ab368083d1d9f892023cd6f50dfae93f57fe33d915065b02f3"
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