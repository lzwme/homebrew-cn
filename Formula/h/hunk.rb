class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "41ee0e79c56fc292d0fe09ed174736048be4662d867ca448506921e7b9a65fa6"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_golden_gate: "7015a2c63789ba3be5330cc3abca004d1408f5f54f497f75f64de7e439737c20"
    sha256                               arm64_tahoe:       "7015a2c63789ba3be5330cc3abca004d1408f5f54f497f75f64de7e439737c20"
    sha256                               arm64_sequoia:     "7015a2c63789ba3be5330cc3abca004d1408f5f54f497f75f64de7e439737c20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "abb5098d0b57e78d89443e5c6f94fcb2620dcb6156314285d542dc975a145c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dbbd755f1b4cbd964abe225c1cbcf127ed5f363e4eba8a155b41f1c7c584b7fc"
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

    # Install the compiled binary and bundled skills. The repository-root
    # `skills` holds maintainer-only documents that upstream does not ship.
    libexec.install "dist/hunk" => "hunk"
    libexec.install "packages/hunk/skills"
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