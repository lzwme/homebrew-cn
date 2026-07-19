class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.15.0.tgz"
  sha256 "772f8e00f719afbbe22502717cf974578804630d02e757eb3debbc08a0f8f83a"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "432e20e13e79250936a69b240f75ad039b31f21c32ca139a992884d540df87b3"
    sha256 cellar: :any,                 arm64_sequoia: "432e20e13e79250936a69b240f75ad039b31f21c32ca139a992884d540df87b3"
    sha256 cellar: :any,                 arm64_sonoma:  "432e20e13e79250936a69b240f75ad039b31f21c32ca139a992884d540df87b3"
    sha256 cellar: :any,                 sonoma:        "b31646b9fc9a1168713c33a8860f2f83e39094296ffe1cd0c43e4760bfe10603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28039e2666aeddaf8c965dda04ef60797edfab1f9c85a302261e2591713a8e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28039e2666aeddaf8c965dda04ef60797edfab1f9c85a302261e2591713a8e83"
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