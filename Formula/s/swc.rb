class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.3.tar.gz"
  sha256 "04c4cd3cbe0dd1bebf0d9b1a00b5cf4671045fd1b9cc8ebb6746f99529435687"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729b1f1fc8d0f8d2d8791f1869a6806e9538bed4d9c76a211afd8c2ba182e6e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9cd450157afb07b977b846c2385b87b54a6871ac2afb501887ad8c9f7bd6cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ffed934ff4a71d10748eed031b32eca0beb5c6830ac0d0e039914996977f4b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "07abef9dddde89ef6a146df376c01dddef74602640e580eb381d9c65859ea65f"
    sha256 cellar: :any_skip_relocation, ventura:       "69a13e2ebd7ee065f23e85127437894a017571706f4bc95814aa5d1204b4f03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ccec1f24658fcb28a06def6169028a7601e777c5b43d5f7d3c4217c24813ae"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargoconfig.toml"

    system "cargo", "install", *std_cargo_args(path: "cratesswc_cli_impl")
  end

  test do
    (testpath"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath"test.out.js"

    output = shell_output("#{bin}swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end