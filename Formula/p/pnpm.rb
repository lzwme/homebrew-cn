class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.7.tgz"
  sha256 "cd935a839f05f740626732c89c4549dcd24e19303df3be2ded275513f93888a0"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "084a2c96c34326200c33ae3ecc378f1e4b7b63b2757fdab064cd41d52ea5c768"
    sha256 cellar: :any,                 arm64_sequoia: "5a1bcbfa2af1fc41fe2be855f0a3212cf1f3ecc364d6d2218fba1c298a1b4b80"
    sha256 cellar: :any,                 arm64_sonoma:  "5a1bcbfa2af1fc41fe2be855f0a3212cf1f3ecc364d6d2218fba1c298a1b4b80"
    sha256 cellar: :any,                 sonoma:        "ccc1216d37e0d7a3c60e388d5c6b09ce03e1991379df1da0cb5429013ddfea14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca9885ab7c79673ab09d3cf9c64752627e61b95a4878f23a5bb2d77950b4c443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9885ab7c79673ab09d3cf9c64752627e61b95a4878f23a5bb2d77950b4c443"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
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