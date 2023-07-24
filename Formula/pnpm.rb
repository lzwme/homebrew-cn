class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.10.tgz"
  sha256 "f8021ef55420c7d7cafe689c2cdb1bf1881d2f75219705ad3ab38966eac283f3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e77ff0269d95e15e5383bf90a1ecd02f966e68c50aa72dd04d80242951d0e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e77ff0269d95e15e5383bf90a1ecd02f966e68c50aa72dd04d80242951d0e12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e77ff0269d95e15e5383bf90a1ecd02f966e68c50aa72dd04d80242951d0e12"
    sha256 cellar: :any_skip_relocation, ventura:        "4cfab43b32c0922799adc53d1ebc7d0d298145b96a6c7dc12b640f08142e074e"
    sha256 cellar: :any_skip_relocation, monterey:       "4cfab43b32c0922799adc53d1ebc7d0d298145b96a6c7dc12b640f08142e074e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ed8d9a8931595ab37c0ae82b87653fbfbf3fb59043a4e95bbafd2824fb34f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b6da3abbe5defb9194b68ef762fafa4902cbf8aab5dda104f7fae4fb08dae2"
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