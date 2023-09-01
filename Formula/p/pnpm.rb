class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.1.tgz"
  sha256 "9f0febfd67c8f4317f4cf2edbf2ff4bf326f0e7dbb2b5b03aa05248f9faa26c5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ed74bc9f6f9455986b3bb9c985ef981994629adce88472ab89988400055a0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed74bc9f6f9455986b3bb9c985ef981994629adce88472ab89988400055a0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ed74bc9f6f9455986b3bb9c985ef981994629adce88472ab89988400055a0cb"
    sha256 cellar: :any_skip_relocation, ventura:        "cb152dbc157d1825b79180da6ad43addb6a6184f2fcb10741fea0bef2a72b4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "cb152dbc157d1825b79180da6ad43addb6a6184f2fcb10741fea0bef2a72b4ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "50a42a301aae9877b32e56102db6194f7fb4ca34066be291b7aec399c0f3407b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed74bc9f6f9455986b3bb9c985ef981994629adce88472ab89988400055a0cb"
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