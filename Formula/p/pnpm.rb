class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.30.1.tgz"
  sha256 "bc8bb877378eab6a8a83114eeb6a31ef88528db4ab5570299baba8fa54da2375"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b75f2bf25882e9e3d596c425f26463ca65ee24190971b8157d0e3cf354aa023a"
    sha256 cellar: :any,                 arm64_sequoia: "1b867889d4b34039b1bef54b7f1c3a81eac1d348d3e51146e9903b620ecf0616"
    sha256 cellar: :any,                 arm64_sonoma:  "1b867889d4b34039b1bef54b7f1c3a81eac1d348d3e51146e9903b620ecf0616"
    sha256 cellar: :any,                 sonoma:        "7b42efd1be274917bc7ea4d766874cb4c19e6f44a2b084d647d6b5c5037f1fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "426a505beca4bfb712e7fc3d2472739002c9e9cf4d40ed144644950a7a7c9ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426a505beca4bfb712e7fc3d2472739002c9e9cf4d40ed144644950a7a7c9ddb"
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