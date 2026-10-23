class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  license "MIT"
  revision 1
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/modem-dev/hunk/archive/refs/tags/v0.24.0.tar.gz"
    sha256 "108120c25c64017d1b608e1aa2b7317dc1bb9220285fdccffcde6c67d89ace04"

    # Backports to avoid using prebuilt bun
    patch do
      url "https://github.com/modem-dev/hunk/commit/96619dbcde205b3a296df6970aa82e46b33e955b.patch?full_index=1"
      sha256 "eed3bd8907546afb602c9f0e9b938b2fded2dc65307d354356d6e7d9ed8a1b0c"
      type :backport
    end
    patch do
      url "https://github.com/modem-dev/hunk/commit/676c172b44acc5610b58f85dfd8cf83dcd55a3c3.patch?full_index=1"
      sha256 "4056af590dcfea0d2b1281aa61bafa4ede32252a0563806400e9f2d6114a26c2"
      type :backport
    end
    patch do
      url "https://github.com/modem-dev/hunk/commit/43138ca1b997a1245fa3d2e5523a140f7d456766.patch?full_index=1"
      sha256 "a77bd2cf62d55206b8fd7a2ceed2ff4d414ac4e2718f8bb2c377ef6004a4015a"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "321c0cc4c043e02e04340159bedd38bc34bd89b57b1600feef9c29e6d16d4c73"
    sha256 arm64_tahoe:       "d4476365df09bf2cdf14178781782e0d1a0edc7983524d3962a18c374f61fdd3"
    sha256 arm64_sequoia:     "630517d54b1ad10c0ac5de1d934b2a662459842a2dc6da1f904700d1de70d78d"
    sha256 arm64_linux:       "9812758c4b26af0e8ef6b313f7335b8126a5a243afe753c8be8580b379227241"
    sha256 x86_64_linux:      "be4ed4a9223b1ea32d0ee3158c10c9e83a4bc4dff6e9abc521b41c1261ff83a3"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    system "bun", "run", "build:bin", "--runtime-executable", formula_opt_bin("bun")/"bun"
    libexec.install "dist/hunk", "dist/skills"
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