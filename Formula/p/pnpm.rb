class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.4.tgz"
  sha256 "7d14339f572583eb550b7629f085d0443166ddbfa25fa32f8420179123fab98a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae02d56b177dd11cfadde66a87c37b2f9ddeb347b4af2b3771a11660f8436c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae02d56b177dd11cfadde66a87c37b2f9ddeb347b4af2b3771a11660f8436c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae02d56b177dd11cfadde66a87c37b2f9ddeb347b4af2b3771a11660f8436c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f713e9ffdb4ba8fc361d383fd1e16eb0584885464a77113d3f2888eb9caaa4"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f713e9ffdb4ba8fc361d383fd1e16eb0584885464a77113d3f2888eb9caaa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20ed91db2fcfaa7db85862d43ac037b17439b6b35f0f14a934787f932a959f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae02d56b177dd11cfadde66a87c37b2f9ddeb347b4af2b3771a11660f8436c2c"
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