class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.7.tgz"
  sha256 "b3ad7183eb222e5131829214fb0d65af68852e891c7a3116c3e240e8ddcadd6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21854097170ec0eb9a6979fcd775f388ad2103b38aaf5a03553494c4090bca35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "517cf2aca75dbdabcff091858a76437ee5417f39c916e2abacf31b36977c1684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17f4df755e24a6f21c12a2a43002a4ef745f89a403ece531412e29f813a577e"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c5bb72867535ed14e4828ab7a54a4e2b8ae10d331162da4985314401699821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f01340e51ecfb69b012e50ec62abe97ba091f28816e7223b07c8fa9f3bcb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210403977e56fbe8e4334d79592796ebed810e7bd207693fc82a670987b2b7f0"
  end

  depends_on "node"

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