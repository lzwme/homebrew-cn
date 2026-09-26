class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.118.0.tar.gz"
  sha256 "12067ce52ad06669442103c383e332c06555afea0922f104de334501a874f9ab"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "23599f5c02f75b37ecbfdf857bf1afea08340075925ad71d0f1e4eab5dbdbb04"
    sha256 arm64_tahoe:       "3b214316689b3d208b107aeb781e9cbf3069d730fccbf24cc383d31b0cd07b73"
    sha256 arm64_sequoia:     "7c55b87b986e8b9afefa05ccd0c8f23aa3da5ffc425c0d3e935c83814726c1de"
    sha256 arm64_linux:       "0cd637c90dd80845aabacae652c07be8d173b60a0b0583f9033cfbfd3058bcd0"
    sha256 x86_64_linux:      "8e2b81e28e546b745b93625b9b505195816517fa1e677ec64d10fce42cf68f96"
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