class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.0.tgz"
  sha256 "fd1eab68a6d403f35cf3259c53780d70b0f14bd74e39da2f917d201f554d8665"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d62654c071ac90a30aae76359364c979594c187cdc20bf542361ff570a95b31"
    sha256 cellar: :any,                 arm64_ventura:  "3d62654c071ac90a30aae76359364c979594c187cdc20bf542361ff570a95b31"
    sha256 cellar: :any,                 arm64_monterey: "3d62654c071ac90a30aae76359364c979594c187cdc20bf542361ff570a95b31"
    sha256 cellar: :any,                 sonoma:         "c6459893fe59f04bf3d623e4c88922fe69e504efbd70d24d3d7f0895f253ddf0"
    sha256 cellar: :any,                 ventura:        "c6459893fe59f04bf3d623e4c88922fe69e504efbd70d24d3d7f0895f253ddf0"
    sha256 cellar: :any,                 monterey:       "c6459893fe59f04bf3d623e4c88922fe69e504efbd70d24d3d7f0895f253ddf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa62188c72a8d21ac2d7416bc69c38d61f0d6b9257b4c95a10ccf194c8131667"
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