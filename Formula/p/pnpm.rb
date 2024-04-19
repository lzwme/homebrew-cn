class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.3.tgz"
  sha256 "f5becd4b77fe9150c8d89423612eb413945114bf6dd00fdcb5940434b84731c4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7031c2eb6f645d24b03cf67b38934004b31a9118c1195d2aa982082b102b01e4"
    sha256 cellar: :any,                 arm64_ventura:  "7031c2eb6f645d24b03cf67b38934004b31a9118c1195d2aa982082b102b01e4"
    sha256 cellar: :any,                 arm64_monterey: "7031c2eb6f645d24b03cf67b38934004b31a9118c1195d2aa982082b102b01e4"
    sha256 cellar: :any,                 sonoma:         "cdf7bd138593e6353e3c272549cf3558b2c85c0095570c9aedc8be4ddfe2c141"
    sha256 cellar: :any,                 ventura:        "cdf7bd138593e6353e3c272549cf3558b2c85c0095570c9aedc8be4ddfe2c141"
    sha256 cellar: :any,                 monterey:       "cdf7bd138593e6353e3c272549cf3558b2c85c0095570c9aedc8be4ddfe2c141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3adcc840e5cfe95e8ec7a5a739d30293fe63dfb4b54837095bb55317481017"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
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
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end