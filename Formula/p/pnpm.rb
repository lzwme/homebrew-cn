class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.14.0.tgz"
  sha256 "9cebf61abd83f68177b29484da72da9751390eaad46dfc3072d266bfbb1ba7bf"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f45adff2ff106a26bf04a9d3551449ce7e6c919b64121deec9413b2ea545cca2"
    sha256 cellar: :any,                 arm64_ventura:  "f45adff2ff106a26bf04a9d3551449ce7e6c919b64121deec9413b2ea545cca2"
    sha256 cellar: :any,                 arm64_monterey: "f45adff2ff106a26bf04a9d3551449ce7e6c919b64121deec9413b2ea545cca2"
    sha256 cellar: :any,                 sonoma:         "bd703bc8f1d2a782ec2229571589a42d2c79f618766f6e50ed5475092fa11f7d"
    sha256 cellar: :any,                 ventura:        "bd703bc8f1d2a782ec2229571589a42d2c79f618766f6e50ed5475092fa11f7d"
    sha256 cellar: :any,                 monterey:       "bd703bc8f1d2a782ec2229571589a42d2c79f618766f6e50ed5475092fa11f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec68105890ce8dcb6788b8757e8b9da6d112e8682f497b5e248b09f3f47b679"
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