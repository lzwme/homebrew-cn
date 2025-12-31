class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.27.0.tgz"
  sha256 "d3c7c3d12d87d177e32f01748d5994fb20cd5becf11670ee60530c374ffeabb3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef72995ddf16922d7a2639c7d13eb4810e507670c50037be4a59313b4b4ea858"
    sha256 cellar: :any,                 arm64_sequoia: "d594ae6058f5772dcfccb96c2ad65d9f778ad5e59d4e3569cd8c389895a0a170"
    sha256 cellar: :any,                 arm64_sonoma:  "d594ae6058f5772dcfccb96c2ad65d9f778ad5e59d4e3569cd8c389895a0a170"
    sha256 cellar: :any,                 sonoma:        "163dd2932c609657cefc22ab2148e40c1de1544d0e95152606ba6708aed136ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b978670d2f6a603bb8359ec368b1be34a11f18da830f408e702df9c555a4bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b978670d2f6a603bb8359ec368b1be34a11f18da830f408e702df9c555a4bff"
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