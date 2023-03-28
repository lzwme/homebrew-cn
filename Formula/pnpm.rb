class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.30.5.tgz"
  sha256 "c8d730294f671574458704cd56e81dc0eb8d345a444e4c7a728d8d2cdc4f5045"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f92b5018e276b52066ff074d2b007b8667e58044f0fc526091cfd9045ddb601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f92b5018e276b52066ff074d2b007b8667e58044f0fc526091cfd9045ddb601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f92b5018e276b52066ff074d2b007b8667e58044f0fc526091cfd9045ddb601"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0b717a59a6b318c3c0d8cf6246007b2b23110013e114edca0f011d418567df"
    sha256 cellar: :any_skip_relocation, monterey:       "dd0b717a59a6b318c3c0d8cf6246007b2b23110013e114edca0f011d418567df"
    sha256 cellar: :any_skip_relocation, big_sur:        "01143edb12a50af87af27ba87493c7ad12bf08ad90147b87bcc9bcd69f442723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f92b5018e276b52066ff074d2b007b8667e58044f0fc526091cfd9045ddb601"
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