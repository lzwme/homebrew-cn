class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.55.0.tar.gz"
  sha256 "61554786fc77767e8b3e0dc9e89ee67803511ac7fb5d49f19af1a35dcb304e41"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbd5d4c8438bfdc885115e9c70dc72fbdd75fcb34390c0fe803177c65e55b9fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ff21614fb801fe98d196b2fce56aa8969da236b655ad8ae44b61a5fdc8ed98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56ca87a288b58154f1fbb4133c9fbf2e2962b75804fbb9540ff68b4476d854a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02550cb02f6e87e7c0cf4fae2a23d6ad5223967d553b48a6bbfec90749c0e9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8fd7a09182af25d6294d192c3c31a2efe2a6d4da3ee2890ea6a0d15cde857a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40bc54511cfedce6b9dc9fa10dbcd22823080f60e70066d1dd547152b879df6"
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