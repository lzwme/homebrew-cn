class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "f37c7e7c492a60f8b4a49cf99581de2dcb6e1c5ba120703790ae55bc596072d5"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "27ea8027c8d212a69b457a35500f8e6df8e5db0938bad6932c71dbb8e93f2714"
    sha256                               arm64_sequoia: "27ea8027c8d212a69b457a35500f8e6df8e5db0938bad6932c71dbb8e93f2714"
    sha256                               arm64_sonoma:  "27ea8027c8d212a69b457a35500f8e6df8e5db0938bad6932c71dbb8e93f2714"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f74e1af69e63f1b5393b5b6098893c5b65ffd4a6b3a0a4cbe517305e93fd631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1cae9d61fcd6490643f685e1ba3579748eddf86820e844de1ecf167c77223cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349872b6f472ca0749ed91fd0dc72877e39eb5bca8b2209745dfcbe13dc0eb8c"
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