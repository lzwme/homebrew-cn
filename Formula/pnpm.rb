class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.11.tgz"
  sha256 "6713c6bb13a7cd01d0cc86032ed1318188d10f4d87fd9aad6f131c81cb008551"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02861f5f7edd42574722ceffc913f4e00a54b9b95eb0467447003f8cb2bfaac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02861f5f7edd42574722ceffc913f4e00a54b9b95eb0467447003f8cb2bfaac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02861f5f7edd42574722ceffc913f4e00a54b9b95eb0467447003f8cb2bfaac0"
    sha256 cellar: :any_skip_relocation, ventura:        "a905c0f5f75a113dd10a1e744650dd94d65fc106c8736b05a3bae02b3bace41c"
    sha256 cellar: :any_skip_relocation, monterey:       "a905c0f5f75a113dd10a1e744650dd94d65fc106c8736b05a3bae02b3bace41c"
    sha256 cellar: :any_skip_relocation, big_sur:        "58b479212fdfd32b826be29a53c52ef5dd4452a414a9f89f2c6b3a47c9359247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7982471d8d80ac7b594862c64d06d7cc53500213a382c7ec7351e5fbceb72bb6"
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