class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.27.1.tar.gz"
  sha256 "003c0cd3721f0adc424a5b8b20217346712db87188f2106512bf7a50f4654ed0"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce11bdc87e31ca783e38eb95b8dc129fabd4a75635ddcc060eebe11a249d0d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af016813a4c131ad2f9f0f1ce96c99aa714843f013ffc4c1bba44c802fb9441"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14c09e348a1ed211fd61ace1b93db6290e589125569e1ddac4c7167e877eb685"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa1e4dae16a406a6fcbae47e4fb7191a196142cf87296bd5227395ecd82a604"
    sha256 cellar: :any_skip_relocation, ventura:       "9c90b2a72822d3cbc32a5bed95b2afc15e98cf410ba14ff81d699cc2a6cc756a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f822a8eecb993371ae046576e34f7de497e25baa08bc1d1969a05f8776ba5a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af45ff6853e9146d0875b8173ddfc4fed820ab9b67c8c32759618756edd65eb"
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