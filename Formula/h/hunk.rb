class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "fb8a602d3f447a846ff76ab654d957efc3a5213af8b10af773b549e3b44a2d21"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "2b9aba67b17bb14d2b7d569634a4a06ca2a254ce2d88cbdd85694e73ab5aa0e0"
    sha256                               arm64_sequoia: "2b9aba67b17bb14d2b7d569634a4a06ca2a254ce2d88cbdd85694e73ab5aa0e0"
    sha256                               arm64_sonoma:  "2b9aba67b17bb14d2b7d569634a4a06ca2a254ce2d88cbdd85694e73ab5aa0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f105a8debbc66cf030cb7d998cc6f7d352ee0141adba76770752523c97e1c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7cdc0cc6d8acf793827e119b7a00861daea2ed89dee73b0a9e8a728d9b427a"
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