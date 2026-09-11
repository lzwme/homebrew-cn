class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.3.4.tar.gz"
  sha256 "4f400669b36259278efe44278e4adfc7f449fbccb4c255670c66332a7a792aa1"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "203d44be2238ab3fa00ae6ea9092f17551b9d8f2cc4c46b5ab913d455d6631a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0eab753988399a13f92a7b229cfaae6c5d1b459cad298fb00e4d6b0e6e930971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f15823bc27936b0dc23303e9a03da4efdc6da25a65eadf3397080357d0599050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7f74ab27d551140249a36b45f0c3143aa279d5fdd13ecdbe12e11d260ca16aa9"
    sha256 cellar: :any,                 arm64_linux:       "0faf5800929412f53a737e17a28d34a9f3561fee9c8fbb058798b5b9d368edf7"
    sha256 cellar: :any,                 x86_64_linux:      "b3c412ab3cea5d5980ad056d63359488973af7e6dd1581770cefcd57471863a1"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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