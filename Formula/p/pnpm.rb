class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.10.3.tgz"
  sha256 "eb2548d6347afc7002a046b7be3ee3c8222bc71f68418dcf9f90fa0a7341c41a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e92326fe9ff78b50bdebd8a0a78a7e911c8d716b51cecf00d45fb667a62aa358"
    sha256 cellar: :any,                 arm64_ventura:  "e92326fe9ff78b50bdebd8a0a78a7e911c8d716b51cecf00d45fb667a62aa358"
    sha256 cellar: :any,                 arm64_monterey: "e92326fe9ff78b50bdebd8a0a78a7e911c8d716b51cecf00d45fb667a62aa358"
    sha256 cellar: :any,                 sonoma:         "9ee7aa20dfb2f452df591fd9f2e08830db052759146d8b7053e263047cb9c414"
    sha256 cellar: :any,                 ventura:        "9ee7aa20dfb2f452df591fd9f2e08830db052759146d8b7053e263047cb9c414"
    sha256 cellar: :any,                 monterey:       "9ee7aa20dfb2f452df591fd9f2e08830db052759146d8b7053e263047cb9c414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b13c34982ecb0d418d378d19c23c27646ade19a8f84b17a14f3143ddac7f10e"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
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