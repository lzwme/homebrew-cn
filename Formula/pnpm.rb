class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.0.tgz"
  sha256 "1e9c17c34c2eebaba02e78b619e296db08d302c296e58c2f51b0cd4e3e5bcda2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b768354368d4fa3e5e9c3e0ff8f4fc0d41f40967283661ad95d3588d6c6cf407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b768354368d4fa3e5e9c3e0ff8f4fc0d41f40967283661ad95d3588d6c6cf407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b768354368d4fa3e5e9c3e0ff8f4fc0d41f40967283661ad95d3588d6c6cf407"
    sha256 cellar: :any_skip_relocation, ventura:        "9fd9907f0c6de459b98bf5b0feb73d047ede27edeb401493a7933c3f744e3932"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd9907f0c6de459b98bf5b0feb73d047ede27edeb401493a7933c3f744e3932"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ff143462a2244ce3896bd584f873515f40aea530314234dd6ceed425ea4686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b768354368d4fa3e5e9c3e0ff8f4fc0d41f40967283661ad95d3588d6c6cf407"
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