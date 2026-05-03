class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.4.tgz"
  sha256 "70369545a94ec3820e64bb15f1ba92a50b81bc685362fc14c685118028f90517"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "430f57f4133d1eb173bf9b618ac5521eb215d56132c61ea7a135d42e9de91de5"
    sha256 cellar: :any,                 arm64_sequoia: "15d010fc296d6d3274e46f6f2f5ce029b567bd40c9708b162d5ed555364c24df"
    sha256 cellar: :any,                 arm64_sonoma:  "15d010fc296d6d3274e46f6f2f5ce029b567bd40c9708b162d5ed555364c24df"
    sha256 cellar: :any,                 sonoma:        "b30ee504c01e39a843ddefe283cc96ac4980f64ae52cf4863bf7f91e815ee889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4b1fd527cd96f936618fdadc9eb87007f6f8bf63efeef128c3f484ffac5d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4b1fd527cd96f936618fdadc9eb87007f6f8bf63efeef128c3f484ffac5d80"
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