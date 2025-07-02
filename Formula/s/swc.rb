class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.12.9.tar.gz"
  sha256 "6bae04b4a8ced7975d87d4b16219a03f7593403289f5e995b2b39d85548b506c"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e245bad6b4d154eeba05209c7068d71288aead31d9731704b97811e8509441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe12fa75319eb5b20ab34cf51ee7ed366d2d568c26eb6226e4825c63a865ce83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bd3dc9b0cf3fc44c3f13e280216ee515e9dc4a1254c250fd80889c72b1ccc48"
    sha256 cellar: :any_skip_relocation, sonoma:        "a21d72df1f41e1f7121949b984bdb0cbbeeb98f7547b898a06db19cd4265296d"
    sha256 cellar: :any_skip_relocation, ventura:       "2144ce3ba7e0cf9fbc0db3400ebdf0c5065c48bcc5cfb533035fda83d5a0d4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1cb17f46a1b7561c4b262a52404b8efda6de72a83974190b53231a00c07528a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4e44e532d7438d65bc9d3dc3f9c056472373a50b955e3f9cd0284b0c82e0a1"
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