class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.1.0.tgz"
  sha256 "ccfd7f19bc0ff34eaa257e5e2c960d357f6f7ed64952ff634828672a7eb059ee"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc85dbdc1308a064702d918668b8665c38b3a952691c2184ed41002ee2743a46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc85dbdc1308a064702d918668b8665c38b3a952691c2184ed41002ee2743a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc85dbdc1308a064702d918668b8665c38b3a952691c2184ed41002ee2743a46"
    sha256 cellar: :any_skip_relocation, ventura:        "9d353be3a6f4cb33a24853e541994b698dd1095b199fe6dabbf2dd6917c8ad18"
    sha256 cellar: :any_skip_relocation, monterey:       "9d353be3a6f4cb33a24853e541994b698dd1095b199fe6dabbf2dd6917c8ad18"
    sha256 cellar: :any_skip_relocation, big_sur:        "90e355cec8fc2a9d4f4f31a59926d44b99bb74b1437a4382a6aba0f30082dfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc85dbdc1308a064702d918668b8665c38b3a952691c2184ed41002ee2743a46"
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