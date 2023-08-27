class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.0.tgz"
  sha256 "aef8d26bc17616c60dcb15d2db30803766051a2720edcc3bd60b87fb8c925470"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4dc3001e33f2102111f226bb43691b4dbb630948796dd995f08112df25cf45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4dc3001e33f2102111f226bb43691b4dbb630948796dd995f08112df25cf45c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4dc3001e33f2102111f226bb43691b4dbb630948796dd995f08112df25cf45c"
    sha256 cellar: :any_skip_relocation, ventura:        "11ff06dfc1e7040087cf38ac852d044e12ee516ae409ecc00128ec146a8a6c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "11ff06dfc1e7040087cf38ac852d044e12ee516ae409ecc00128ec146a8a6c5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d4db838fdcf5866418304d7b192e1ecce3de024e3b5846a7a6613e6f5aac9f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4dc3001e33f2102111f226bb43691b4dbb630948796dd995f08112df25cf45c"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
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