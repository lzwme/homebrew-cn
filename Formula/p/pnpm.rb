class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.5.3.tgz"
  sha256 "238d639a47712278bb72e8b6db2c297ac1ccd80dd7642f7c933b73aebde7b51f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b2a69aef320e611b833bd1392378884a753e69e50728707a18bc7ea10cbf0fa"
    sha256 cellar: :any,                 arm64_sequoia: "af962910989d0741a775a5598e29f15044ab37bfcae7a9defb183cb0a44daf31"
    sha256 cellar: :any,                 arm64_sonoma:  "af962910989d0741a775a5598e29f15044ab37bfcae7a9defb183cb0a44daf31"
    sha256 cellar: :any,                 sonoma:        "64bb9e11893790db46195eae81e24692f9adcc440a14c38b33c87aa00f7db1b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e294c28e92a617dff8de12c32187a35cfe508b9d38ea7370d7c066e952a49aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e294c28e92a617dff8de12c32187a35cfe508b9d38ea7370d7c066e952a49aab"
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