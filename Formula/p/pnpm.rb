class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.14.2.tgz"
  sha256 "a2dd287205a53bb4322937530d4a17f86269f63fe00a62a03e9e458d3ad027ff"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8806c1f5971dfea846dda027ac6c043ba910f936f0435593af5b66f91f890bc2"
    sha256 cellar: :any,                 arm64_ventura:  "8806c1f5971dfea846dda027ac6c043ba910f936f0435593af5b66f91f890bc2"
    sha256 cellar: :any,                 arm64_monterey: "8806c1f5971dfea846dda027ac6c043ba910f936f0435593af5b66f91f890bc2"
    sha256 cellar: :any,                 sonoma:         "6763118cece178c5105745300563cab0f5e32bdb4d8af8c1aa45b5e57f3f2067"
    sha256 cellar: :any,                 ventura:        "6763118cece178c5105745300563cab0f5e32bdb4d8af8c1aa45b5e57f3f2067"
    sha256 cellar: :any,                 monterey:       "6763118cece178c5105745300563cab0f5e32bdb4d8af8c1aa45b5e57f3f2067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa349a3a034c43a0cda1d232291c80858802860a6fa043baf7a4c8830afac5d"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

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