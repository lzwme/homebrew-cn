class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.12.tgz"
  sha256 "a6a0f7696f5dbe779858cb4e24149bb515e4104caf60dccc0ffba83907951d07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a126b09a105949b97b93fdefc463003da0b123c2412b35d487ff3742415d3f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f967946847b5cd1312676f0b73750f2c056bb4cfdab2af8aecb4548b68963ff3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8061e7d96ba5de1e539db034b70749b408d968d701976156dec024d139bb849d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0bb9b6540601caa8b596fbfbcab3dc40f70e30c2f55a60bf4b5e0f84eecce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18a2b1a5458b67f536010cdf26f9c1fbb774a0e5db2fe8279a4b260d9b21be58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ddf518ccb3070f5c9da3cc830b18bf63d7c85bb6710ded8d28b4f8c9c7d7865"
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