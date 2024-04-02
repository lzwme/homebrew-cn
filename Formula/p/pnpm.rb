class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.6.tgz"
  sha256 "01c01eeb990e379b31ef19c03e9d06a14afa5250b82e81303f88721c99ff2e6f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2de2aa0effdfaac69c4be6ff788dca18f17a4a0d66e62c4c1ae0de6bfb658494"
    sha256 cellar: :any,                 arm64_ventura:  "2de2aa0effdfaac69c4be6ff788dca18f17a4a0d66e62c4c1ae0de6bfb658494"
    sha256 cellar: :any,                 arm64_monterey: "2de2aa0effdfaac69c4be6ff788dca18f17a4a0d66e62c4c1ae0de6bfb658494"
    sha256 cellar: :any,                 sonoma:         "2b17c0499f9226d8a82c3217562e395e6fd93b99644ad479780def5c50eff4a9"
    sha256 cellar: :any,                 ventura:        "2b17c0499f9226d8a82c3217562e395e6fd93b99644ad479780def5c50eff4a9"
    sha256 cellar: :any,                 monterey:       "2b17c0499f9226d8a82c3217562e395e6fd93b99644ad479780def5c50eff4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c096d69e09fd440ad819c83473e563ca41189151330655984bf2a09e989bc9a"
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