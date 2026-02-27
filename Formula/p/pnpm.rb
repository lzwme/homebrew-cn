class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.30.3.tgz"
  sha256 "ff0a72140f6a6d66c0b284f6c9560aff605518e28c29aeac25fb262b74331588"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "051c49cff9760cb72b7c60fd800a43602029b699acd7f5e43a1417d95260be08"
    sha256 cellar: :any,                 arm64_sequoia: "f1d8c3238b86ff11ae03d8c8ff1468283958b7df589da94dce712839bd3be273"
    sha256 cellar: :any,                 arm64_sonoma:  "f1d8c3238b86ff11ae03d8c8ff1468283958b7df589da94dce712839bd3be273"
    sha256 cellar: :any,                 sonoma:        "994e1ed4771d7d679d7504dd6b117b9b11793efcf9ef83ed31e4284a63368fa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdf2bba4380370cd77db1f7eed07d18c5def381f8f913cd17fa4847efd2a40c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf2bba4380370cd77db1f7eed07d18c5def381f8f913cd17fa4847efd2a40c9"
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