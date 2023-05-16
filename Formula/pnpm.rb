class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.5.1.tgz"
  sha256 "422dcb3af61ee44b2c55d8737226590134f8f5009e617fe708734d3a69a50811"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f03b7d71510ab3cbdaea9a601e7e3cf251e2ac606204d0a4553626095715c7a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f03b7d71510ab3cbdaea9a601e7e3cf251e2ac606204d0a4553626095715c7a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f03b7d71510ab3cbdaea9a601e7e3cf251e2ac606204d0a4553626095715c7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "79358e112ebbb336f56aaff82025cc776204c4d0cafcc90a23d3c926c541115a"
    sha256 cellar: :any_skip_relocation, monterey:       "79358e112ebbb336f56aaff82025cc776204c4d0cafcc90a23d3c926c541115a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6626c8cbb54b2ad7a11e72bb2e91079cda402b0cb652c54046f7c919e6f6804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03b7d71510ab3cbdaea9a601e7e3cf251e2ac606204d0a4553626095715c7a3"
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