class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.12.7.tar.gz"
  sha256 "4b8a7988943ded37449c5be65d878ba9b810e656e41118ac848a30c79137e4cd"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c94e6ddfebae335d5283463717e0e223dc8f511f363b3c2be04d8a6a8cbd5f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb8da4cfa57348b1b7dfe5b4f7a22b927dee9eac202ca2349fa44b4927b856e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dbe1c9b90466b88c2085589f210700f8693c7ec01308d01ecdabf9e3a089f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "47d74e9def85a210ac6f1c28195ebb75cefe20449f6d6b84bc81cd4086f5d3c8"
    sha256 cellar: :any_skip_relocation, ventura:       "b97feb93ef05765cbca10f538ca27cea7262c4e77f90505b78f38b38804973ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225eabfaec0c1231ac0ca2fdc8e1af6c2787392eff647924208e0efbe306b781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b16fb2312d60eff0716b97e49b5cdb154fce5ae5b2822ffceeb3af61839f1f3"
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