class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghfast.top/https://github.com/PRQL/prql/archive/refs/tags/0.13.6.tar.gz"
  sha256 "929f9c76b685029b5bf7d5852bb735558ff664290b766fe3d531893377d1c67e"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4438f5f86cea8bad43aa330fb7ec47b68c9bb489b4a36fc532edeb2a24b9967c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4febaece1de29a6bbcafb0a6492cf26d774ea6bf524c341acb3cb86bb420666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2241800a230cd6fd005864af444661906f8c11d1ac2540825138274c58b737"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a108d479c54e04e11d8e7e2dff6f42293fbd47fce71aa9abd3cafe5180625a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "045bdb4516b2e23e1ff5a47430edd66af65eb7ffdb8d1d5e95d3d5cb8d1353b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ea9e5cbff542e041c86d7f941de9ea9d2fb72eeffe3dde74bd2fabcac6a4ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end