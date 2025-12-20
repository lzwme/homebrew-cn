class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.26.1.tgz"
  sha256 "e8e6e499128f6804f5c92223cd1f2e3f62557102c0c6e254cc99bb2aa229bbf9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab984ac0923cedd5e36646aec5f0a4bfd69bcca1271ab64336563e552583719a"
    sha256 cellar: :any,                 arm64_sequoia: "1f5a42b42d4ad66aac204226d30164519d5736e3ed82d531c0498fda62fc849c"
    sha256 cellar: :any,                 arm64_sonoma:  "1f5a42b42d4ad66aac204226d30164519d5736e3ed82d531c0498fda62fc849c"
    sha256 cellar: :any,                 sonoma:        "4abead5da6dfb2a0a94a42fa0e8b3ca7f21609de830caac735cc3f416788f7c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb29717d969c96b209fedfc0f2e96bc7e8bfa3bc1285a839ce5833e9427592c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb29717d969c96b209fedfc0f2e96bc7e8bfa3bc1285a839ce5833e9427592c6"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end