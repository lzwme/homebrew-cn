class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.2.2.tgz"
  sha256 "99c4be831ed231829895142d96793dbe75afc53795933aed8366e68dcce1e1b8"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e3084d966ff0588260a8852a96a7cc2e463887351e7f5f15a54573a894f61ee"
    sha256 cellar: :any,                 arm64_sequoia: "9ffe841579a1aecd03e0be021cbfd2aa866fd8b2d2ed39a1272319b57f8603cf"
    sha256 cellar: :any,                 arm64_sonoma:  "9ffe841579a1aecd03e0be021cbfd2aa866fd8b2d2ed39a1272319b57f8603cf"
    sha256 cellar: :any,                 sonoma:        "19603127bc2f4ed2bfd6ee552ccc0cd179b03460c3013fc4be95a6d05736871f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe0dbf23aa7e10b4fbca3bb845479baa83d3452ff2963f49ecb1ee7df30f92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe0dbf23aa7e10b4fbca3bb845479baa83d3452ff2963f49ecb1ee7df30f92a"
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