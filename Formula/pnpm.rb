class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.9.tgz"
  sha256 "c94450b6623ecedb5e8c7045c7e67cb240bbe88e17660b3d8c57207dfd1eff90"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef8245febc3db51cf45c1ee24a2f3203d67873b5e77672e836da0c5f50148a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef8245febc3db51cf45c1ee24a2f3203d67873b5e77672e836da0c5f50148a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef8245febc3db51cf45c1ee24a2f3203d67873b5e77672e836da0c5f50148a1"
    sha256 cellar: :any_skip_relocation, ventura:        "5624aa676c2943dd8ff029e50b38ff28df024a544bb8efe84a41eb938bd28d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "5624aa676c2943dd8ff029e50b38ff28df024a544bb8efe84a41eb938bd28d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1181c020b28af39e386e73dd5e93547db996ed62e66c8f3a3fd1a1142b585985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef8245febc3db51cf45c1ee24a2f3203d67873b5e77672e836da0c5f50148a1"
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