class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.7.tgz"
  sha256 "50783dd0fa303852de2dd1557cd4b9f07cb5b018154a6e76d0f40635d6cee019"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8d7d13faf42b5735020046a055c7222e62fc1ec8baa7e342a7238ff8317af59"
    sha256 cellar: :any,                 arm64_ventura:  "f8d7d13faf42b5735020046a055c7222e62fc1ec8baa7e342a7238ff8317af59"
    sha256 cellar: :any,                 arm64_monterey: "f8d7d13faf42b5735020046a055c7222e62fc1ec8baa7e342a7238ff8317af59"
    sha256 cellar: :any,                 sonoma:         "c72c7e5b336c8009c5965d1fdd4af07a46bafab5b0e3126c8f48781caebe6002"
    sha256 cellar: :any,                 ventura:        "c72c7e5b336c8009c5965d1fdd4af07a46bafab5b0e3126c8f48781caebe6002"
    sha256 cellar: :any,                 monterey:       "c72c7e5b336c8009c5965d1fdd4af07a46bafab5b0e3126c8f48781caebe6002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea36ce48c3435f17c6c3f59ca1f0113d7111f5ddb15ed665d2b2265fb374e816"
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