class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.29.2.tar.gz"
  sha256 "35ea5ddbc3f998eafb6f476419d6279af4745e6d7a62dbefdc0efaaffefe9530"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab42a6cd71e9119b2f00d9dd80231d7ac5a78e9a150fca961cfbf761f14c427c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878a54cc07683d382580e12dcfc9e1a549bfb993d7bf721d0274c1c4cf45700a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "051a034d8d85048da0de995e2309890d15d0f1ba7617bbd27659b64399dec36d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d2735bc9852635fa15e76ef8a133d43e06e477752abe5ab2560b6aa6d46ac3"
    sha256 cellar: :any_skip_relocation, ventura:       "6a2517d28d629c7b07e3ca6cd03d9e923148121e2a949766f28bbe1d0e954d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a095747946b0431daa9d835c4c6a54bda86027579f3376ecfa1154fb2997be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8b6056fddfb78106825e668113c71eadbe53f0412b27a69f8826341e5f3685"
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