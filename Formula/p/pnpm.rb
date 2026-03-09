class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.31.0.tgz"
  sha256 "6f61ced1a27558d13cdf52008f2bb302a03638ff09dd236562a97f0ac59d37c3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f12607751a90a68ca032e57bdbf956ff8012c2e6d08d71bdba64575ed30e93bf"
    sha256 cellar: :any,                 arm64_sequoia: "2c4c8942b9355a2ad2d0c8bbb6018cca5997f1f3074b65a5796c9c0407c345c8"
    sha256 cellar: :any,                 arm64_sonoma:  "2c4c8942b9355a2ad2d0c8bbb6018cca5997f1f3074b65a5796c9c0407c345c8"
    sha256 cellar: :any,                 sonoma:        "3d0876432b79ccd72a48fc3aa701d498ae1ee252749abf6f381fb91f0c210dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2684e3eab35e7ef26f8aa7d83a72a2c605293500c18b1bcb78701478890a0945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2684e3eab35e7ef26f8aa7d83a72a2c605293500c18b1bcb78701478890a0945"
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