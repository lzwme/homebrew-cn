class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.14.0.tgz"
  sha256 "cc60acc3fcb413d4741cd16800e9d9d8e68e680e571e49b84848a3922e99183d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc66b941ba0f5f99e594e39ef4837c26c9ea5d25bcbdf34bd47ed0ab4f8e457a"
    sha256 cellar: :any,                 arm64_sequoia: "bc66b941ba0f5f99e594e39ef4837c26c9ea5d25bcbdf34bd47ed0ab4f8e457a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc66b941ba0f5f99e594e39ef4837c26c9ea5d25bcbdf34bd47ed0ab4f8e457a"
    sha256 cellar: :any,                 sonoma:        "7cbebc506f8457868e1595c5ca095cc4e4edd925568ccb1fa574a940040a3bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a628962306739a0bd1cd10bc99a344204ee3f4ae9b958dbc94bbe474ca0bacc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a628962306739a0bd1cd10bc99a344204ee3f4ae9b958dbc94bbe474ca0bacc6"
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