class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.12.0.tgz"
  sha256 "1c2bf108d767b976353c2c1e9ad14d240cebb99d4bef4d93a7f1a9d10da5b817"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "347bf5cf21f7419d1c7a02676169eb92f175d24947f65d95d9a5371a7d10d0b7"
    sha256 cellar: :any,                 arm64_sequoia: "4c93eb487b36b08293ca3f51850e90b2cd46cad768ec6aa168d6e231620b0cb0"
    sha256 cellar: :any,                 arm64_sonoma:  "4c93eb487b36b08293ca3f51850e90b2cd46cad768ec6aa168d6e231620b0cb0"
    sha256 cellar: :any,                 sonoma:        "8cb8da90f71ad87fa3ba7f665ac1352f1ca1bd47a0fced88dcf41416c8f09d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e20d94548dc9d0f72fe86d0fde1dade861d3ccce97b9fb4325922babcd6e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09ca78ec7dcd04db4ac75c68f8351750b25820060a2ce40d31044e771fa7a1a"
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