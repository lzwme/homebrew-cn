class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.41.3.tar.gz"
  sha256 "affd4c3333f42a26c73257c877936cf80e07f247332c314c75ef3fc39bd1bad4"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdbcd0c4f3e582ccf32a8ed36be471d06b796d6235cbb44dd85acdf989dd23b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd70328e09e88c02d2011a5cc07abc0e58fa68f050d63b10e7d854a175b09511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bb6831a99978fb5a14b671048e97e460ec39a7425b55d427fd6f2ccfd280aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c00da54ab2a1034b9dd0351becdb62beee2d4f38c56ccd5a896691af6c50dd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a298de289b0b5e2d052fc97cee530649758c6c8e2abbd7f129ef7d21c2fae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375aec6a8302f6395d1861850bd81882a187728481748a715a9ac8f8e18e2ecc"
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