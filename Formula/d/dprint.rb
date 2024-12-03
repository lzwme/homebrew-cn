class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.47.6.tar.gz"
  sha256 "8d0095f6f35f11621783ab40fab4a9394829b96c3d1de8e844d319096d25a76d"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "442f5dc9615639365deb0a6d9beeb7c12455f29026b7ef2e9f31fd418c4edaad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a6c7c79cb0ec694d1b331fd77615b42386b27959a4ef512e77635ad3c196d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee833f66c006546733df75aef02d162389867e5dfe1b992d9eeb8ced34e8edbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "66261b8fe4d1f1e25c5b26e0b12c3e35a203e380295b142ec50bbe9642b8ea67"
    sha256 cellar: :any_skip_relocation, ventura:       "ae55ec367e7aee017a7823a9b3d50f13b67f2e724e634bdbc3bdeaf694c14cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af5b8e0eb21fcf4f1923b30bca549e908729f40e1eb1d9a7ca13d8bff83b600"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesdprint")
  end

  test do
    (testpath"dprint.json").write <<~JSON
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
    JSON

    (testpath"test.js").write("const arr = [1,2];")
    system bin"dprint", "fmt", testpath"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}dprint --version")
  end
end