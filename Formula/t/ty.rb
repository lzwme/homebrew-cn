class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/3b/7d/2fd9575bce2d14e2281bec82d0713dee68329b0dc944e9c06c2e36b761fe/ty-0.0.83.tar.gz"
  sha256 "db118de73c05ac476faceb4d42d59782feaeddfc4d721fd3ae8b807a0a2ae4e4"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f5ec1d9312599c18fd95aaf0287a90bd5e8b7856ed37cfc55c705f0710240fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "579ada33154a67ad9c49c2af1357817470f65b70bd5f01a07b97fe00fbc0c8b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d1e6dad27c455e984a2d34c121d1512e307a308f67ebef0662edfb01a91e96a"
    sha256 cellar: :any,                 arm64_linux:       "f8a629131102729c3d3f7750bdddf057d04db47929e1c3077e6168000e5d95c3"
    sha256 cellar: :any,                 x86_64_linux:      "5bc36469870a411a86a244932000cea86aed6643e6542a37d8a65b0ec249ea69"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end