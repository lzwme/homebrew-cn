class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cc9b5a6e3df9cadf09fa165c3c4fc26e13ed51c6a678e655343384d408d18126"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "0fa67fe904025b5244f936690a30f83283dad26091cbd258fa161caac4e57c8b"
    sha256                               arm64_sequoia: "0fa67fe904025b5244f936690a30f83283dad26091cbd258fa161caac4e57c8b"
    sha256                               arm64_sonoma:  "0fa67fe904025b5244f936690a30f83283dad26091cbd258fa161caac4e57c8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0635d4b2d1b8061ee3b3c3325d993c67d46882b91d5f4cebb0a9984591f1e6b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a884b7a7d29ab237d2b8a30c135c499467873172ea5ba8fe9810057340380959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ab229925f01e1dd10ba82d578384230789ad0dba38028c9c9016e6ea61d7f7"
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