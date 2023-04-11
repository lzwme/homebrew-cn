class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.2.0.tgz"
  sha256 "15f5639529363c67c47a03827800e0ce9df072e59765bd3b5334bbb50efce9e6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fc73b8a9363e1afdf7f7cf448d8aec7856a7c6871fc13c44a6845ac97c40318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc73b8a9363e1afdf7f7cf448d8aec7856a7c6871fc13c44a6845ac97c40318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fc73b8a9363e1afdf7f7cf448d8aec7856a7c6871fc13c44a6845ac97c40318"
    sha256 cellar: :any_skip_relocation, ventura:        "ac98a7bdef7203cbfbfd238e6d6e61a38450321aeeb531b14abd0ea82d691c92"
    sha256 cellar: :any_skip_relocation, monterey:       "ac98a7bdef7203cbfbfd238e6d6e61a38450321aeeb531b14abd0ea82d691c92"
    sha256 cellar: :any_skip_relocation, big_sur:        "477473a2f2a9a34edc20cd0cd2ce6bbab8a7bb721b07349a064b64ffe14f9067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc73b8a9363e1afdf7f7cf448d8aec7856a7c6871fc13c44a6845ac97c40318"
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