class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.7.tgz"
  sha256 "fb41f6cde380621a838e99632ef78778b682d57e2c937895afb5c497a11ceb6f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "604f3dcf103304be9500509ede68851bdcffc18891b4379210d0aa2565a831b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604f3dcf103304be9500509ede68851bdcffc18891b4379210d0aa2565a831b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "604f3dcf103304be9500509ede68851bdcffc18891b4379210d0aa2565a831b3"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe28823dbf869110884465e065f99a2b2eb0ad146777f15a1e4b014aad3895d"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe28823dbf869110884465e065f99a2b2eb0ad146777f15a1e4b014aad3895d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1962a8750875bc1c179ecc9158df7d6204d513acdef5693e9fd73bee54131a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "604f3dcf103304be9500509ede68851bdcffc18891b4379210d0aa2565a831b3"
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