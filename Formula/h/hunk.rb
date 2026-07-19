class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "bc6a0fcb169a18be88757b25d3a39171c61a176efede48f3d4539e151765d619"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "0a4083583de3a507b2805e3d16fb2cf50c0f89a8d6f24c28633dd15cb6319272"
    sha256                               arm64_sequoia: "0a4083583de3a507b2805e3d16fb2cf50c0f89a8d6f24c28633dd15cb6319272"
    sha256                               arm64_sonoma:  "0a4083583de3a507b2805e3d16fb2cf50c0f89a8d6f24c28633dd15cb6319272"
    sha256 cellar: :any_skip_relocation, sonoma:        "d143edae7dcf026ee9114591b5097a4ac79a15c8380c07a484a7de2bb09100dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92702f2f25c0b2a622370235cf5dd98d8fb89641f7b359b6e7936c7094aa8b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc3efbe01f99ca47a9a5dbb9708a48ce1d0db6df11a0b4fc8ff702aa86d6853"
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