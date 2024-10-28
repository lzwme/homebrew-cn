class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.47.5.tar.gz"
  sha256 "bea9f14c5576ee5aaefea14839ae1f89005b4681fbf539b31460837bfa2bf92d"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b003302224b4692aab0425bb7bed09123501ec1de139a19b31c42bcc9a0b8758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c757138e6139c3dd8bff6e58aad8f775962e403ef2754c012eccc6fa582d21b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e4e38898a0571f7642c0978b390ff07b8546a47eadc4cd98e493c472c2cc65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "78b64dc7c66f2c74880f8e6de322dc7db891458e1c9db817bc0f810acb763903"
    sha256 cellar: :any_skip_relocation, ventura:       "ad520eb3d82e9ad951904a7d77d0619076cf726a32f00d421c440caa1371f145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e7142153bb2cbc3217cc8f84663d8284f90e3f8a28a34dcce09c635e92ede7"
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