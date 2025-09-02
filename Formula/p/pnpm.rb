class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.15.1.tgz"
  sha256 "8c53af02ae3ec1fb0ae75377f8d4d6217c2d7cbe6f03c16350cabf7493de6eff"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ef46d64dae91ffba33ca25bd009d4e94fd3e8c9584a334fe97b1949a425c6ca"
    sha256 cellar: :any,                 arm64_sonoma:  "1ef46d64dae91ffba33ca25bd009d4e94fd3e8c9584a334fe97b1949a425c6ca"
    sha256 cellar: :any,                 arm64_ventura: "1ef46d64dae91ffba33ca25bd009d4e94fd3e8c9584a334fe97b1949a425c6ca"
    sha256 cellar: :any,                 sonoma:        "17330fc19f9c4ff3fcdc88c097e192f0353a74bb5c7f2e6d31308ded1854801a"
    sha256 cellar: :any,                 ventura:       "17330fc19f9c4ff3fcdc88c097e192f0353a74bb5c7f2e6d31308ded1854801a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55a6acd6f403641337cd7610b5e406dc6b965cbd80c0358fc04538b83a9cf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55a6acd6f403641337cd7610b5e406dc6b965cbd80c0358fc04538b83a9cf1c"
  end

  depends_on "node" => [:build, :test]

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