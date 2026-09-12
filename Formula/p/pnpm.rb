class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.4.1.tar.gz"
  sha256 "7388d1fe40ff2862d97645d4f5fca9f4a2459ac534c005d990717298aeacef6b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35fbf8bd23bf2ed90fdf70caa924c1182142562bf81ac9b3517023ac3d3cc84f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c902946d697b30e93dfb200e635e773f18bf396538fd83011d374785a1f32c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcb4c6e7d941dd36bdba96c185a50fc3fc342bf8dd5fe97e0a9809789910d86f"
    sha256 cellar: :any,                 arm64_linux:       "d073ad1f1bf648bcc7107eabf3ffa04f27ee084105af5b84444dc73138029c36"
    sha256 cellar: :any,                 x86_64_linux:      "a4aae3264cca8457a012b05d432e9ef536d521bda3b56f864b1762efbaef3969"
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