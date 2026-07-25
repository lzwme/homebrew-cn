class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/ba/ce/cbeaa5c7576fec643609dfbf200d59493523b1cc0481d4e7a5effcbf0630/ty-0.0.63.tar.gz"
  sha256 "c2f66439393b3acac69306c117d4ae44638ce5fffa4a20c21046e85bd473359f"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85dc1ddaf1230ddeeaa0a2ebd5926fada29ccfea9c1e4ee0d9344bdda0f9377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b399b16a1c8e71abee46d862702a371692509be9e46c61e73d694bd9fb2cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f9cb9d488f0e342a8d2ca7bd796073c63b988ecfbb7909d268c18de50a6ac48"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bfbead280458a0dffda56fdf648c56250c3370eabe997075517944051dbfab0"
    sha256 cellar: :any,                 arm64_linux:   "58aad48b87c858da2620b1feffbea28d9518b7822393e79c83ad2d9dc37206d1"
    sha256 cellar: :any,                 x86_64_linux:  "291cc6a4835dd6f8934ca3822697dfa6ca33e0ce513e17127c3c44184e0ef03e"
  end

  depends_on "rust" => :build

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