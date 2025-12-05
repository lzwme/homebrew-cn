class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.3.0",
    revision: "a159f755ca4bf8307a0cab01494ae2526437eb89"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb2d530bd9c1a5cb39e468bc3199b2ab3bcd03db92cc30e384fb53080efde684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e4ef866d0828f219fb50ef05e636457c3598d9e35c7a8d28a0a5242e92a568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a04b5cfd2195e26ecbce8046c371b681b2aeeab81d51285cc667d790c256a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "44635514fdd814aafd6178634238e106be755318f9f01fad128aada0a48b0796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902fe72bea7b8a2322c49f6ef891d52292fddb116b0ba4ed927f492cf4f1447b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c65150cdda273b99eafe4b3977a1d0c58bd359336755f4764c0c23e7526beed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end