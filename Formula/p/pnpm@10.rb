class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.2.tgz"
  sha256 "7a7bcf13d7f6ceb3946c03978373d99be9fde1cafc3000bdfed4c4f791167610"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8fc2e5fb5841db7708969c24ca29c5b8fdee1faec02e2c7012d039855f658a2d"
    sha256 cellar: :any,                 arm64_sequoia: "c108c9383b0aeaaa7332bb015e733f185299bd7ac2fccb907eb081b35630fdd1"
    sha256 cellar: :any,                 arm64_sonoma:  "c108c9383b0aeaaa7332bb015e733f185299bd7ac2fccb907eb081b35630fdd1"
    sha256 cellar: :any,                 sonoma:        "c99c7471951f39b1d2332b563fd3ef258ee60e1c85aacf3d936cc16ea42ebea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711e4394740fd6bce7c6bea8748e6802a921a9dd9c8e9311d762e333274cf014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711e4394740fd6bce7c6bea8748e6802a921a9dd9c8e9311d762e333274cf014"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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