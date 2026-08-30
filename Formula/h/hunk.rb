class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "a2493e124e1f4b67e5f85ee67e593a5d84e5f5d58c0621d5b4ac019d9c6470db"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "e18471769f711a33e006009a2c0cbe680ef55ded798a6e55968e3db78c1a92d8"
    sha256                               arm64_sequoia: "e18471769f711a33e006009a2c0cbe680ef55ded798a6e55968e3db78c1a92d8"
    sha256                               arm64_sonoma:  "e18471769f711a33e006009a2c0cbe680ef55ded798a6e55968e3db78c1a92d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f3707988210371916a50799a25e3f73ae3234890a2a2dda339d66ae318b7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b081942696923580a53d63c05b3d6cba4abe4399066e2e5d930ddb2bb72c765"
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