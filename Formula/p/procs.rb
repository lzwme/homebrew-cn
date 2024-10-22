class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https:github.comdalanceprocs"
  url "https:github.comdalanceprocsarchiverefstagsv0.14.7.tar.gz"
  sha256 "e8abcd188213ea68835cce92519cfcdb70315cc1821eb3f74cc6e967ddce28ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beaa93e63f9d03536433469ac0c25825a6cba32707801784a70d03c54ee17a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c301874edb0c84a26f43f62ae8ef1443f6c89393c2606904941c42ade04938"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "090e31996499d6b8b1b0b9e6aa09044cef0d417d249aefacbcc30e908e3e2e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a350e112db6a193d7e4de3da71b7c021fdc0e574a60d70f12cc4f6c87eaff96"
    sha256 cellar: :any_skip_relocation, ventura:       "8d61505cd0717ddde1da398a4a6cad50eb019bb4cd34041e96a84df9aea98d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ee7d77e189377c996b0499f7a192a112e30b30d656d7d01721d37d19525fb3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin"procs", "--gen-completion", "bash"
    system bin"procs", "--gen-completion", "fish"
    system bin"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end