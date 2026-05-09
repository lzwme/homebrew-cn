class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.10.tgz"
  sha256 "80d3575d54cf3a278b96fb87f52d22259d4b8ecc325454c216c791d7579be78f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b4bb56ecffe17ea8aa3c64472dec4619a05d0f5d346bb7ea42c906078946972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ffd2413203639120474e7f003f4d15f407572e486044f382bd5c0c3d49fcb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d817142da72db2407e6c4e0c5eeb415de2f945e6fa13afc90e684eb40db2892"
    sha256 cellar: :any_skip_relocation, sonoma:        "45869691900edaf2e5b849245d91ebeb0dacf719b2b19008937149041d0821f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410c3ab633a8e80f33de93863950235c083991b3dcbb5f80ad9dea6997406e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c322c519c146f19c9a28df5bf11cd65aaf3ec9dcbcc30edfe556441817a688"
  end

  depends_on "node@24"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)
      system "npm", "run", "--prefix=node_modules/better-sqlite3", "build-release"
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end