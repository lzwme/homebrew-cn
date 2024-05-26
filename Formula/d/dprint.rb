class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.46.0.tar.gz"
  sha256 "9941ecbc3a050ef49a9403d6ea1c62ab57e1f7c49d9be3a5023dd7d506217fff"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2e59f0e516a66c0dd3e7d57052000f35a2ddaaf0a26b46ce35dcfcd0c753229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc38e818afb9919f8ec670f3094f67f1d5593471711d3fc7579f989e0536a1ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "842828381572bc821aa8e75ad9c25275bfb74770ebbc2b75b2fc6d4e81e24498"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f5d4a072cfc3507eda7a102b3c5c5d61e9448a03e719604087cccb2736c0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "7d2802312636fea627f20d48d81605fbcb083676376394e0cbac7124e2412ae3"
    sha256 cellar: :any_skip_relocation, monterey:       "80743c52388ff05c4be60941ba3abcce90df33d5405819be84f2a711406a61c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6820ad0dcfa3ad463b6ec5317486984d8f38eef0ac1a9d270ac37f5a4aa6a8b7"
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