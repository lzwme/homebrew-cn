class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "4f87a39cec8dba98a27a05362d5e96e12b60fec3d112554e1d22d2f6fd7c6101"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "6e2e3415c2fcea4c2d6f88512fa3a34faa23994753471b63bd9e9a3247062826"
    sha256                               arm64_sequoia: "6e2e3415c2fcea4c2d6f88512fa3a34faa23994753471b63bd9e9a3247062826"
    sha256                               arm64_sonoma:  "6e2e3415c2fcea4c2d6f88512fa3a34faa23994753471b63bd9e9a3247062826"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a296f926977388ad6634ac785442cc6ad90962d7fa0dcd2a4a5fc5184c373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f09dd0c3e7b8340123e2a8fa86de39c5204ebeab2734f304746b39c8bdd74f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c072d22d97302144e08b6763fcbcbcc2fdab5b785e40af59b52e52084a2b05"
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