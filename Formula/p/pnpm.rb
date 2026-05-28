class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.4.0.tgz"
  sha256 "e74106a5a0eb2569f4583504420ead5fc1c263e417a3216cab1cbe0ccdcb4eae"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d90fe2e3ca150d1829c248dcbb52d8799793e3453d81585ac6436b7f178efa0"
    sha256 cellar: :any,                 arm64_sequoia: "d5b77522d70d2988e7fe8129319f37048501a9f92469335217692e58ce3919f6"
    sha256 cellar: :any,                 arm64_sonoma:  "d5b77522d70d2988e7fe8129319f37048501a9f92469335217692e58ce3919f6"
    sha256 cellar: :any,                 sonoma:        "1e373aa67164bb8c9a8a1d2b4030a487ea32cbd178f9c7febb562403075c8e30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3af56f767bce9a3f22479b9aafaa8d1bcb37cf8c2418df8730c7eb87b0106d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3af56f767bce9a3f22479b9aafaa8d1bcb37cf8c2418df8730c7eb87b0106d9"
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