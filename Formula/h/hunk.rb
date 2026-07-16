class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "f21998d94edc5f4919500c0e9a0331ef1dab9b43c42db634711155b13ec5a22a"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "e79315a034bd596ccc6e8417617d88af4fd5190565a21f74045fc5555a228cef"
    sha256                               arm64_sequoia: "e79315a034bd596ccc6e8417617d88af4fd5190565a21f74045fc5555a228cef"
    sha256                               arm64_sonoma:  "e79315a034bd596ccc6e8417617d88af4fd5190565a21f74045fc5555a228cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "001e0109a2437f5d9824310ad33163040862b10d838904b0c1714f9bb92825e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac20daa578040542f337e22143294d93f7f8fbec18f2e439dafd40d0b45e01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "610ae1dc17b72a2a1a8876e74aff79ee8a83480f084ada525b2a5490259925b5"
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