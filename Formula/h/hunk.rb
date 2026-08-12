class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "25684b4a087c2dba3776d62aa9f419fd9a4b0359f7fbee5f8fe6540404627385"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "d1d80c360a7a95cdd69b61c79ff505b673d20ff6fca23cf9185a925246307be0"
    sha256                               arm64_sequoia: "d1d80c360a7a95cdd69b61c79ff505b673d20ff6fca23cf9185a925246307be0"
    sha256                               arm64_sonoma:  "d1d80c360a7a95cdd69b61c79ff505b673d20ff6fca23cf9185a925246307be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c182cddc928e48435b11f427cd6295fffb2f057afac510bf9a461b31aba764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a4682595ebaaa7ac04b49696cbb4184bf66103468ce91535013d3edfebc5bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6cfbe3936b5437aa4e563d150e06feaeedf4558297fe4f84f73a6fd3011e9fb"
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