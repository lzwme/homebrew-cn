class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.41.0.tar.gz"
  sha256 "3fa9774240df4dcbf6cb322fe0ea3c7a2b4fe14ce1f3cac08a26b694b96accbb"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5163225c7b001f33773510a9d61689b3ed5ee648b453c03ab5205104867344d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5455d0d61c2806154db1b20f10027e7341fd611041ca8e01df84c53f08d85e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7a234e303144c7f4ef923f4e157da42c2647baef6a61ffd6fc01e0a414c3c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae6039e2f1c7fc12d02159ea6c8344e22f20958d715683fe8a4b1fd28dc4677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87df0ab02398c0f1fcf506a934faeec3aed47553e42a3263bc516d39f8ddaf09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57c71dc8e13a29da554af95c529c6cebc47e7bed119f8b9aee07c7beab0db35"
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