class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.11.0.tgz"
  sha256 "5858806c3b292cbec89b5533662168a957358e2bbd86431516d441dc1aface89"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bda8356a84ae61c9ce0f1a4d16ade37f5869544f39070678d97415559631dc9"
    sha256 cellar: :any,                 arm64_ventura:  "1bda8356a84ae61c9ce0f1a4d16ade37f5869544f39070678d97415559631dc9"
    sha256 cellar: :any,                 arm64_monterey: "1bda8356a84ae61c9ce0f1a4d16ade37f5869544f39070678d97415559631dc9"
    sha256 cellar: :any,                 sonoma:         "3d23014d761eab96260558c0bd73e1e9d53554c4559d01ab85dbc32146ae76c1"
    sha256 cellar: :any,                 ventura:        "3d23014d761eab96260558c0bd73e1e9d53554c4559d01ab85dbc32146ae76c1"
    sha256 cellar: :any,                 monterey:       "3d23014d761eab96260558c0bd73e1e9d53554c4559d01ab85dbc32146ae76c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe7a0db24b4c1c2bacdc058532b8a3471a7916e7389ff0098df186b3177c64a"
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