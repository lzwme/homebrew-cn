class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.47.0.tar.gz"
  sha256 "bb0a092528730ed712d7c6f3b3193165c9ecabed857b481f95f050a00c9ab3e3"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08ec78cfa4f0f9cefabd8e8fa93604cbb91fdd1b693f5549abcaae7c40c61916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c763500d4000a6dbd3cb60608cff54814ea8122f6f801eab0cf0daba426e703a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25708cedab3e69129bc10eb6e1eab3415e46d152174dab931435e99ef0d33c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b5bd942602b7530f950823a25ee9aa6a47f94d2a02a763d151ea742b9f3213d"
    sha256 cellar: :any_skip_relocation, ventura:        "5617c9722bb7271ae00bd77c3a9ce505bb46737a032f78545ef0361cb21b6223"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5cf953519c74655fe7c7ce432cc8a2b8d59bec7fe8e73ade4532269fb3c9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac991da2124b697ff3fb96af6c1da5a5944b31268adb92d3cdc4122698f1389"
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