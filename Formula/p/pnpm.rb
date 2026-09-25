class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.6.0.tar.gz"
  sha256 "6c347d76658e36de554848799e0725547781a5b5b040477d6e2d62a09c5efbaa"
  license "MIT"
  compatibility_version 1
  head "https://github.com/pnpm/pnpm.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bd8ced6cdddb9d5e9e6f82748b2af46b3ab9902f54556d7f1a6dcc69603ecc5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "992093be5c1c74e6381df91f12dfc06dc65f79c63c979ae359a086bf0433b3da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db6073a770a9fa857b123bbf117a5543394cb95fcb6b88a8988b07f5ab206861"
    sha256 cellar: :any,                 arm64_linux:       "b0cc2fc7bf7b85b2098d72025e708f53e8d7fe13f1552fb7cbc4e10280702746"
    sha256 cellar: :any,                 x86_64_linux:      "7c1a3161a01dc1f93abfce2c18995e7496f4fcca5b2610d93d6230237ca42ac6"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pnpm/crates/cli")

    # Upstream ships these beside the binary as shell scripts rather than
    # symlinks: the `dlx` injection for `pnpx`/`pnx` matches on the name of
    # the resolved `current_exe`, which a symlink would report as `pnpm`.
    { "pn" => [], "pnpx" => ["dlx"], "pnx" => ["dlx"] }.each do |name, args|
      (bin/name).write_env_script opt_bin/"pnpm", *args, {}
    end

    generate_completions_from_executable(bin/"pnpm", "completion")
  end

  test do
    # `pnpm init` writes a `packageManager` pin naming this exact pnpm, and
    # every later invocation resolves that pin against the registry, so
    # anything that must run without network has to come first.
    assert_match version.to_s, shell_output("#{bin}/pn --version")

    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end