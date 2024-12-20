class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.47.6.tar.gz"
  sha256 "8d0095f6f35f11621783ab40fab4a9394829b96c3d1de8e844d319096d25a76d"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f36fb7cdfe3968d85bfa770c7f43e9fb8bbe649994495825860868b3f99a428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbcf1acfcc67af149369fadcb917728d095f3aa7b4dc7bb3890fe21a6ddccbbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b450f4f94ed7ea5350e7c450e2ff819bcac47cdf575424c7b53bb30668a24b58"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd965baa9637e33a253ddc82b98f1508e1ce30a5df2ff8fc9a796f82fae0adf0"
    sha256 cellar: :any_skip_relocation, ventura:       "67919f18e35d2e2888f818d4d33a3bd889d817139c74874d04e6da570d601c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "951ed0523ed6d5f6e6fef11986bcaf5addd0fe4c2bceaf94406efa87ee42eb77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesdprint")

    generate_completions_from_executable(bin"dprint", "completions")
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