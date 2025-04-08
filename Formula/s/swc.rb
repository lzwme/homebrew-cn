class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.18.tar.gz"
  sha256 "59c393326a3a18b1cbd97e0620cac861445d6dfac97d211f75f8156c349332f3"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f63ccf940a7df8f1d491a4265f6513ce083ba1d7421b60338234e8c395c8009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a716c88331a7b940d869006313c5ada39a168dcf0334ff8f54e28b6004331247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91edbe953ddb947098a1c16a9642569a21cd1dbb92c050757c34125be12e12de"
    sha256 cellar: :any_skip_relocation, sonoma:        "83549131149e120505f6d6c7dd0c918c96fa1881281d80e56ccacc4d7b42cbf5"
    sha256 cellar: :any_skip_relocation, ventura:       "d7c5e2399afaf0cd16e6549dc9e8c8c23ecf20f3c56e94ace17dba7e017ee68c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44b3d6168f28537f54ca54135619d7d46b17df0208b6f6d7924a4199e20b884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f443f7dd879ff146e2876c433886e9c24f068076ccf699e72f48cb3541c24a"
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