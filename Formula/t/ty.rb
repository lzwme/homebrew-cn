class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/66/8f/8de9c4ff90e7131a3c832ea074e123d551fed84c899d37a522f649ca7c6a/ty-0.0.85.tar.gz"
  sha256 "ef442cbc2fd6dad02eb00dee4213c1e0f18e09bcbeec2cdce6aa802603c5c6bb"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47865a64a4d48bca8f3092b1c1195bc15ac8184439bdcf3167cce18a0fff0ed0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d6ed55c8abbd4f3433f22f8743bcc3844d92789653ed2f79fb11f42414c4f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a60b78a957273d94869111fcf3af47c3d4c2e6186fbc35341ffbff4b9360e5e3"
    sha256 cellar: :any,                 arm64_linux:       "9d91b3f01e9e7c36b2b9a88f7c6235d55419b55de4260a1b2004456115e73da5"
    sha256 cellar: :any,                 x86_64_linux:      "88147081501531493fc9484e7121f8b9451a0e371eef1b866ff1a39be7a62783"
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