class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.121.0.tar.gz"
  sha256 "1333db3d6e3a83526745eb6400e46355f85ed14d46b504dbe87ec5920f2e81ec"
  license "MIT"
  revision 1
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "82d211b07cb051558b4ab79da9a5b287af7534a6975afdc09453fac5e76c0736"
    sha256 arm64_tahoe:       "1452124bbc8d56e3aab53617c4d8f6f44cbfe73a8ed868ebaed7f8aa374b914a"
    sha256 arm64_sequoia:     "5985b2c8c72d7796d9e94dbb310767823224090f71c04a973a0490c99a46a451"
    sha256 arm64_linux:       "3a0a8a0bc9f8645425bde554cfca6c697c8cd111d4f5397116e921e5679302af"
    sha256 x86_64_linux:      "229fca363dc14ec72da162cb41f49e161579e193b213de8846abd8b06b233187"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "apps/cli-go"
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    # plpgsql-deparser imports @libpg-query/parser without declaring it, which pnpm's
    # global virtual store cannot resolve. Link it in rather than patching
    # pnpm-workspace.yaml, which would invalidate the lockfile.
    deparser = (buildpath/"node_modules/.pnpm/node_modules/plpgsql-deparser").realpath
    parser = (buildpath/"node_modules/.pnpm/node_modules/@libpg-query/parser").realpath
    (deparser/"node_modules/@libpg-query").mkpath
    ln_sf parser, deparser/"node_modules/@libpg-query/parser"

    # The tag archive carries a placeholder version; upstream inject the real one at release.
    system "bun", "apps/cli/scripts/sync-versions.ts", "--version", version.to_s

    libexec.mkpath
    ldflags = "-X github.com/supabase/cli/internal/utils.Version=#{version}"
    cd "apps/cli-go" do
      system "go", "build", *std_go_args(output: libexec/"supabase-go", ldflags:)
    end

    cd "apps/cli" do
      system "bun", "scripts/build-binary.ts"
      libexec.install "dist/supabase"
    end

    # supabase-go must stay next to the shell binary: it is resolved relative to
    # process.execPath (apps/cli/src/command-internal/go-proxy.layer.ts).
    bin.install_symlink libexec/"supabase"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end