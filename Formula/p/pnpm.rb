class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.28.2.tgz"
  sha256 "afa99b0b4b3d11c1dad2b472f9318ae2c78673829749ded527f89f09071479a7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e369920da4e0b452ed7f7379727e2de6bbeda6d493bb91e5023261c2575450b2"
    sha256 cellar: :any,                 arm64_sequoia: "67e7528374cbb1d1c21c8068ad8474f6e8d60862a868ba15bfb61c03eeb1514e"
    sha256 cellar: :any,                 arm64_sonoma:  "67e7528374cbb1d1c21c8068ad8474f6e8d60862a868ba15bfb61c03eeb1514e"
    sha256 cellar: :any,                 sonoma:        "f67e9c257ecafdf705bde1040e766904d34969bb9c6dd84566ed22f8f2c45274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c79a54cb4ab0b417727d6237742f24f5a1b739d0e5f14e939961ae77dbf718f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c79a54cb4ab0b417727d6237742f24f5a1b739d0e5f14e939961ae77dbf718f"
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