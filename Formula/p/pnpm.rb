class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.2.tgz"
  sha256 "90bb5d6382cb2cb8b8d4959a076b3953d84d1d94121717097bcd41c71344fa14"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01b6a44645bdfc6ab03bd2156d7d84a5dd6f5eee46967fc0b9baf9d81ca67bc2"
    sha256 cellar: :any,                 arm64_ventura:  "01b6a44645bdfc6ab03bd2156d7d84a5dd6f5eee46967fc0b9baf9d81ca67bc2"
    sha256 cellar: :any,                 arm64_monterey: "01b6a44645bdfc6ab03bd2156d7d84a5dd6f5eee46967fc0b9baf9d81ca67bc2"
    sha256 cellar: :any,                 sonoma:         "396aa2d720f3028da7e7420a45871669b7c28b20687a46d7b04ccecadf969178"
    sha256 cellar: :any,                 ventura:        "396aa2d720f3028da7e7420a45871669b7c28b20687a46d7b04ccecadf969178"
    sha256 cellar: :any,                 monterey:       "396aa2d720f3028da7e7420a45871669b7c28b20687a46d7b04ccecadf969178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5aaa9c44a1289ab6aac148bf4238906e697423b40d6a9630f9f433e388335b"
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