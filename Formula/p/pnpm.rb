class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.4.2.tar.gz"
  sha256 "2fca2c303b978c8177c13550b2d0f8e442cf32b833bea7878421f90c18a7c612"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b588226918748f8c40e75f146041c692d82d585072cdf480edc010e8f11e544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c63a0fc02ffe96b2daed111033bd6a0031946fa63d756635440d58ff41d58f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0f751553beabd227719a12b6e05e1c9673dabfba16091c5f552b3e73fe8bf85"
    sha256 cellar: :any,                 arm64_linux:       "3decc717b5170c49b82f7d765d9fae2c2963d9926ae0127bc2697c593eaa0d89"
    sha256 cellar: :any,                 x86_64_linux:      "3bae211cc035e0bf33b17f3f7c5ac69ba8366c988fe5a8cb8c2f6a3d38e567a6"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
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