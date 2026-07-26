class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.6.tar.gz"
  sha256 "40d2ee4f7e5cc76e8600f23a677c194f1753f3f6258db687705d55375d63d194"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "39692fca4e9aa51a6253cabc97c2a08c6e6d49a26d16217429a1c4f0e3e2a72f"
    sha256                               arm64_sequoia: "39692fca4e9aa51a6253cabc97c2a08c6e6d49a26d16217429a1c4f0e3e2a72f"
    sha256                               arm64_sonoma:  "39692fca4e9aa51a6253cabc97c2a08c6e6d49a26d16217429a1c4f0e3e2a72f"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e5f778a1ed9fee287d0786748037ea7b13f0d17209cf798ebce6cc84e9da78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b576b62ca378ec421ad3de68eb978f34367909ece6714daf9a393af5a2dcc0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4243ea7372126835234dec4ff267fed085cfab7379467d7cd7633909430a59b1"
  end

  depends_on "bun" => :build
  depends_on "node" => :build

  def install
    # --ignore-scripts skips simple-git-hooks postinstall (fails on extracted tarball, not a git repo)
    # and bun's postinstall (needed by bun build --compile), so we re-run bun's postinstall manually
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    Dir.chdir("node_modules/bun") { system "node", "install.js" }

    # Build the standalone binary (bun build --compile embeds the Bun runtime)
    system "bun", "run", "build:bin"

    # Install the compiled binary and bundled skills
    libexec.install "dist/hunk" => "hunk"
    libexec.install "skills"
    (bin/"hunk").write_env_script libexec/"hunk", HUNK_INSTALL_SOURCE: "homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hunk --version")

    help_output = shell_output("#{bin}/hunk --help")
    assert_match("hunk diff", help_output)
    assert_match("hunk skill path", help_output)

    skill_path = shell_output("#{bin}/hunk skill path").strip
    assert_match(/SKILL\.md\z/, skill_path)
    assert_path_exists skill_path, "hunk skill path did not resolve to a bundled skill file: #{skill_path}"
  end
end