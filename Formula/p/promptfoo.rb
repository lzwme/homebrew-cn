class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.9.tgz"
  sha256 "3ed21092bece051fb7450614c648cfff7a54ff622f150f26de19c5c7f1fadbb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3276507685cb03e7d526984999075244587aff30f282f8dbb083a1dc11c57551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e0bb90ee913890cfe02d4a1851fbffd320e548ff1822eb2e07f9ead5d54435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5abcdc342022891975a62595abbf81c87db29832dc36a5ae3d6540417d68d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "52898573fdc8e9cd2014477f0c7a6df4282881c4571cba86bc8aaa531bdba571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a0a63b90224503e19c05e2562eb65f7f054278e747909a1693f3e2e5c74c8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92c2f58c40e046ad62d5a9ef880a20b61a93e9dc24eb3fe3d4c72b58b8e0328"
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