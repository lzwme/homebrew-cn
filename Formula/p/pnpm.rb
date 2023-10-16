class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.9.1.tgz"
  sha256 "0bbdbc6f227fc4e5308b79236483b092a755799c42932e85fb8916a30c75a47c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe400211021d6d63e5ad0637e6cdbc5ae4cf80b370bb242f79d34ab5cd676872"
    sha256 cellar: :any,                 arm64_ventura:  "fe400211021d6d63e5ad0637e6cdbc5ae4cf80b370bb242f79d34ab5cd676872"
    sha256 cellar: :any,                 arm64_monterey: "fe400211021d6d63e5ad0637e6cdbc5ae4cf80b370bb242f79d34ab5cd676872"
    sha256 cellar: :any,                 sonoma:         "a08e61c0e981ee1b5acd50ce9db88ad22fcaf22aa3c68a9e8142cabbcae4cb39"
    sha256 cellar: :any,                 ventura:        "a08e61c0e981ee1b5acd50ce9db88ad22fcaf22aa3c68a9e8142cabbcae4cb39"
    sha256 cellar: :any,                 monterey:       "a08e61c0e981ee1b5acd50ce9db88ad22fcaf22aa3c68a9e8142cabbcae4cb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab59a971dce2f42346fe2d8b7fe37419aaa7fcc9e13516ce1a163d20d94ef30e"
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