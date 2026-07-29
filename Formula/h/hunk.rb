class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.7.tar.gz"
  sha256 "147a23fc72aa6f76704dba08b8847d25dacec4857440f5579db57dd068f23921"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "333be141f1f459e701222d08570a6a62a2ad3ceaa1d6279a8b949cc6b3303d39"
    sha256                               arm64_sequoia: "333be141f1f459e701222d08570a6a62a2ad3ceaa1d6279a8b949cc6b3303d39"
    sha256                               arm64_sonoma:  "333be141f1f459e701222d08570a6a62a2ad3ceaa1d6279a8b949cc6b3303d39"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c865ab363c3eedd0020adcfbd7ff9c91552d97fa4cb3964ceec0a4317b69aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4e4bc3a13afb0945c40866254f5e8227af73911df24305e1a08b15e5ecc6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add24b2793199611589e110b777e580b3d9403b9582e62980cb7c0c222ff3c7c"
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