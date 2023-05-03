class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.4.0.tgz"
  sha256 "d1a8ef1df5ac0b2898c157fdb056ae16ff167abb96d8f153eaf5f8b8823a29bc"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdacbec1a8c391e93c365b9b063f1f6d57d3be0bfc9f688cf4b4479ef07ecda0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdacbec1a8c391e93c365b9b063f1f6d57d3be0bfc9f688cf4b4479ef07ecda0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdacbec1a8c391e93c365b9b063f1f6d57d3be0bfc9f688cf4b4479ef07ecda0"
    sha256 cellar: :any_skip_relocation, ventura:        "6d47d20b079f7f25dc4b55b74b4beeb094f89ab8ef5b1b4b0e441df9d98c7284"
    sha256 cellar: :any_skip_relocation, monterey:       "6d47d20b079f7f25dc4b55b74b4beeb094f89ab8ef5b1b4b0e441df9d98c7284"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d68cf418b1fed059f08db813df18117cd5b6c5f5ff2211490d2f76b0975d4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdacbec1a8c391e93c365b9b063f1f6d57d3be0bfc9f688cf4b4479ef07ecda0"
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