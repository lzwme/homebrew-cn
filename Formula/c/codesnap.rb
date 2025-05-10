class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.12.5.tar.gz"
  sha256 "8b8fe2760ff373e5b3efdce684470399453c7313c554f1fa33b19c94804f56a9"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d856b602c69bec1edf844fae1d0b0db478990fe0b056ce2fd3cf634f11b6fe25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d5cf99e309f65de7e6165718b85fc74540575cc54527c39b2edba6f42abd08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f25953da13dc2dae3225af0efcbe0a204e430f880fdafa5923c86d286ac5e07"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15706d9be90b1b0ccd44c5ec4d9eebc1e0f0dc7631f89d08eb183269c568cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "f13fadf12e421eda053d94332f7573fabff492cc3625f29e9788a454d0721419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d0c7295d6f4e6cf3ba195a8a21aca3fddbfb0aa50a3a42caffd485947b6195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a765e3dc0617d7f66a6983b2f1466f068d0986cdfc26d888cc3792416bd4c926"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end