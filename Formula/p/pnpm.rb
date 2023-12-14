class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.12.1.tgz"
  sha256 "28ca61ece5a496148b73fabc9afb820f9c3fec4f55f04ce45a2cea0a5219f2e1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c6d1e82c0268a55c19ad59169acf50ac589b5bfdff28705e6951b63b744a2c5"
    sha256 cellar: :any,                 arm64_ventura:  "8c6d1e82c0268a55c19ad59169acf50ac589b5bfdff28705e6951b63b744a2c5"
    sha256 cellar: :any,                 arm64_monterey: "8c6d1e82c0268a55c19ad59169acf50ac589b5bfdff28705e6951b63b744a2c5"
    sha256 cellar: :any,                 sonoma:         "b4deb8bb235a587b62d20aefc11c6625c0aff83a914faf6b13a4ad0be5e539cb"
    sha256 cellar: :any,                 ventura:        "b4deb8bb235a587b62d20aefc11c6625c0aff83a914faf6b13a4ad0be5e539cb"
    sha256 cellar: :any,                 monterey:       "b4deb8bb235a587b62d20aefc11c6625c0aff83a914faf6b13a4ad0be5e539cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "341881c71c5bc5dd8b969b33568b597c899e87f0af7af8760961b01da6b0bfac"
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