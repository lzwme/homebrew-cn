class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/9f/45/dd3278e1f16bd9ff110b9ecb061ce073b51143ca2bfa891cad71aa567da9/crytic-compile-0.3.3.tar.gz"
  sha256 "b0461ecff11e4be40013e4267a8e20221ebe25c3226e446e60e7c103baf7efaf"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c6784c1a513e80306e6d6b99a0960096374d405798e8e51391dca6007e66dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c67b4dc656180d88100f1a76d3a0e9c297e26836238dc3d859881614d486a83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc0c055bc820f28bec0c0b7b2b65283a7d4cbbcd25d74bccc82611ff009e274"
    sha256 cellar: :any_skip_relocation, ventura:        "e1dce635a2a4c2a94ccd4d626d4616e109f00266a5d7dffa65df5c785e6cbe4c"
    sha256 cellar: :any_skip_relocation, monterey:       "230f955f0adff4c5b9fe37b3160e711458ff7cf9e799102ccca920f19847fd24"
    sha256 cellar: :any_skip_relocation, big_sur:        "111efc29cb98c7249bc831d76d820e28f31f19abd3eadaea2b4fb2f5888040cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954e444b3d6568508e602f892a3803805f5a689e7b7d8c2ef42628750d767cbe"
  end

  depends_on "python@3.11"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.11")
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip", \
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end