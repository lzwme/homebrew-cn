class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.26.1.tar.gz"
  sha256 "cb3a894a045ef5a2488db522f87bdedf31d642854bc8898bc1779c760d02edee"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eea480a5cd209764c609c1289817bd93322fc4a90bf6ed1f37416d4331f1dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631b17eb6a049ca5025bf5d536bbc108937a4d8b9f4e1517bbc2d799b1a321ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfb1a49c5e7b7aaa4b7c485d41cc5318fa9511f123b5426579c1d1ca7b93e99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b2b7965dd8053150ebdbca809ff39efe877a3f8aee7755f313e1a96f947fd80"
    sha256 cellar: :any_skip_relocation, ventura:       "4774d8e2a6192454aba94785f57abbd8028b3373da129432a835f43bce49fe72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7274ddd1b856908300fa5bd9c59753dbb46e66af93a643ee1a85f91a6528570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92bac047a9c209c9cf0346038757cfc2b78bab57e9c80d27b2972b2523cd9617"
  end

  depends_on "rust" => :build

  def install
    # Currently uses nightly rust features. Allow our stable rust to compile
    # these unstable features to avoid needing a rustup-downloaded nightly.
    # See https://rustc-dev-guide.rust-lang.org/building/bootstrapping/what-bootstrapping-does.html#complications-of-bootstrapping
    # Remove when fixed: https://github.com/facebook/pyrefly/issues/374
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end