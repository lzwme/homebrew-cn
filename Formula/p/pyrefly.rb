class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://ghfast.top/https://github.com/facebook/pyrefly/archive/refs/tags/0.54.0.tar.gz"
  sha256 "a94031147bfd14c24b6122b1e391f7e274e4fa2283eaec6012cdbc84dc0dee1a"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "227fbf909cf5164a8b0df40e4b93b821a45e0b8b0fad47d6c10a9c4659b7caa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b115a17d974fb55477693ce32b3e7ecf0c3b6b92b64d8261c59a7cb49f9308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429703510b856bfe42910caa9e377eb76f62609c756bb837998976b5aef69fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d6fcb8f51937be885853f479d76527b8274d61616f031f491f9c22e0e03b9e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1eba3eab6d91a389569d3f99339ed8285ded82f8e34a1f222575d6d15aa1bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f41c1ee6c6f7733d3320b874debc53e4656e409f6fb03535ac77ea734751751"
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