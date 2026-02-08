class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.29.1.tgz"
  sha256 "958f3137511c16c30a3102d52229c695311661e0e2ed7af8d4f3c4a43f73335d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63a49c221fc937fbe1031e4e0b021be5a7567aae98b5789c500bbc273be3e6f6"
    sha256 cellar: :any,                 arm64_sequoia: "d0af24c313440a9700d885edd06467aad267d204732f4d5699334611de86d838"
    sha256 cellar: :any,                 arm64_sonoma:  "d0af24c313440a9700d885edd06467aad267d204732f4d5699334611de86d838"
    sha256 cellar: :any,                 sonoma:        "64495c228feff6a62be65c8ed2e358c29617ca4e47345759ad78d9e1461c9fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d085ae502e00c5a969eb5088b6f94590531543bf5c217388557e945586f28bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d085ae502e00c5a969eb5088b6f94590531543bf5c217388557e945586f28bb"
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