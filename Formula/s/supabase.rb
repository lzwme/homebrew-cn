class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.122.0.tar.gz"
  sha256 "67aca53ea123ffa3d385800eb858e3bfad08923fa77347f8d611f5a0d63245fa"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "0b9f04b4d9fbeb2693c14e910e7d61368a8a7183c5d1ba1dbc96383baa534a6f"
    sha256 arm64_tahoe:       "b86c8c19c914b8d2ffd3c4f9433354677fce683d8ac2b4813bb3fd51945dff3e"
    sha256 arm64_sequoia:     "93648a15b41a22297cfa22710479b23e3dfaaafb9086376d4f61cc78e2fbe918"
    sha256 arm64_linux:       "410cc544e9d3ea8308adb6a8c8a5eb7c7344047ed6912caf96b7dc6fa2173fb6"
    sha256 x86_64_linux:      "487576c0fde9b06a828390457dd2b438c68c5725cb964c15bc322c1040e9b894"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "icu4c@79"
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