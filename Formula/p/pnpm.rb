class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.12.0.tgz"
  sha256 "553e4eb0e2a2c9abcb419b3262bdc7aee8ae3c42e2301a1807d44575786160c9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f05c9ffd703e526fefad3031e68088af1110aaa5c489cab0732a4c9aaae5302"
    sha256 cellar: :any,                 arm64_ventura:  "7f05c9ffd703e526fefad3031e68088af1110aaa5c489cab0732a4c9aaae5302"
    sha256 cellar: :any,                 arm64_monterey: "7f05c9ffd703e526fefad3031e68088af1110aaa5c489cab0732a4c9aaae5302"
    sha256 cellar: :any,                 sonoma:         "ecfb21584d39554599b21893e17724cacdf1468166447460feadfaa99d34c362"
    sha256 cellar: :any,                 ventura:        "ecfb21584d39554599b21893e17724cacdf1468166447460feadfaa99d34c362"
    sha256 cellar: :any,                 monterey:       "ecfb21584d39554599b21893e17724cacdf1468166447460feadfaa99d34c362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220175d08ce224dd1ef8f3a1d1d1c964e18e0d50f85d4119541b8dabcbdf918f"
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