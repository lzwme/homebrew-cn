class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.9.tgz"
  sha256 "4d84d7b0e31c9054f61658795698070007d03b7238481e2161a562557aa90834"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49335b05589b5dc792692d70133eb7acb4f93c1f0877395baf2d26a6cafe4a98"
    sha256 cellar: :any,                 arm64_sequoia: "ade0c12ea24f270dfdd2ca2dc1319b28686a377057bb572b1acccb77cd301489"
    sha256 cellar: :any,                 arm64_sonoma:  "ade0c12ea24f270dfdd2ca2dc1319b28686a377057bb572b1acccb77cd301489"
    sha256 cellar: :any,                 sonoma:        "a65079ec3c1980f614106fb4f4549d60bb7b0d96bfbba5b240acfc02ae30c4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7c783fa4b1bd4a50a53e0ee412065a367014d36d4fc71ce577779cf54183e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7c783fa4b1bd4a50a53e0ee412065a367014d36d4fc71ce577779cf54183e3"
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