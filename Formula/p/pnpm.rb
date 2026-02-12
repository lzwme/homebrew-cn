class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.29.3.tgz"
  sha256 "a74f4dbd3f5a7ca874d004135271f0b697b683bf1fd2fc2133961161cd25b29c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e71cd5e53f520e6a40923d7bfd50ff56260e94d1755ffa5e40626094cf3010d"
    sha256 cellar: :any,                 arm64_sequoia: "acc271287fa4725ed05ed978020e11155d7baec36a6924d0462406a8049d2efe"
    sha256 cellar: :any,                 arm64_sonoma:  "acc271287fa4725ed05ed978020e11155d7baec36a6924d0462406a8049d2efe"
    sha256 cellar: :any,                 sonoma:        "d52640837a6396cff0667e55546e4ce9567a5b7640c7a11307a4b009ab103f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e39b094a1340f8004c5e4aaabf5a07d8d1899b9035f05c3b97c23dc9736433bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e39b094a1340f8004c5e4aaabf5a07d8d1899b9035f05c3b97c23dc9736433bc"
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