class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "9427e9cb18fae86902a352002499a272bd3309c55d91e1e39a602f381aa4e1f6"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "742fd1884152321ad286712fe542c886968d0ed085f16a6f58ebba88485be79d"
    sha256                               arm64_sequoia: "742fd1884152321ad286712fe542c886968d0ed085f16a6f58ebba88485be79d"
    sha256                               arm64_sonoma:  "742fd1884152321ad286712fe542c886968d0ed085f16a6f58ebba88485be79d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10bf1ef1f4bba7a1907692f5647eb910a48fe68952fcb8dcb5f2fb8c27d44975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d664d205f66f47df0b273d8882946ab49ebfb5e4c4cfbfd791a53257eff59f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421213f1d33a8bd17e1e5c39b8daa637951913d96f2701ab307585b407cddeda"
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