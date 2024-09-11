class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.10.0.tgz"
  sha256 "355a8ab8dbb6ad41befbef39bc4fd6b5df85e12761d2724bd01f13e878de4b13"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b2ae42325d3a117856ef6d3a83e68f30b03d6760a805f5f574fa88fdd99fd961"
    sha256 cellar: :any,                 arm64_sonoma:   "b2ae42325d3a117856ef6d3a83e68f30b03d6760a805f5f574fa88fdd99fd961"
    sha256 cellar: :any,                 arm64_ventura:  "b2ae42325d3a117856ef6d3a83e68f30b03d6760a805f5f574fa88fdd99fd961"
    sha256 cellar: :any,                 arm64_monterey: "b2ae42325d3a117856ef6d3a83e68f30b03d6760a805f5f574fa88fdd99fd961"
    sha256 cellar: :any,                 sonoma:         "497f3ea786b175525ac7f115b6c58e08bdf7199025411838cb14dc393198706d"
    sha256 cellar: :any,                 ventura:        "497f3ea786b175525ac7f115b6c58e08bdf7199025411838cb14dc393198706d"
    sha256 cellar: :any,                 monterey:       "497f3ea786b175525ac7f115b6c58e08bdf7199025411838cb14dc393198706d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07156ca50f2cac6c702def1a2c6da32e3c27d0cfac0e573f4e75a0e4aa0bb0f"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end