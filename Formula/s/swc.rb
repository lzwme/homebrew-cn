class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.17.tar.gz"
  sha256 "d7692e6b139b17a8f5bbe7979677ccb675c3fddfa4dfa1729db5362328772d9c"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b9bff8a8d26c81d555630cbfaa60ea186bcbf06f264bddba89999d7cd138c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304ed1eb7690583918ac51100032df76290492ca6b205dfe9525e0b5607a2651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f99b611c76f470dc2bea8aa4708b047596304efcdaa0e58c3c20cda28c5af06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "713419819a4c3887192148c56d966233a9cff967edce81cfb23b1bba771f824a"
    sha256 cellar: :any_skip_relocation, ventura:       "5b0fd7f9d45669425b7eb25388459e7e030f0cf54fbd00a6acd386816f2e9177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fcb8dd5078ba8bcb5e910de22a94356daf3cb90c6ef52ccbfbac5f96a9efd4"
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