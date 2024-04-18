class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.2.tgz"
  sha256 "d6fc013639b81658ff175829ebb9435bcb89eff206769e460fd3ae27c2054df6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47542d31f20ff910ecd667f251254f369cd4410ab40dbfd43f6678dc48f1549f"
    sha256 cellar: :any,                 arm64_ventura:  "47542d31f20ff910ecd667f251254f369cd4410ab40dbfd43f6678dc48f1549f"
    sha256 cellar: :any,                 arm64_monterey: "47542d31f20ff910ecd667f251254f369cd4410ab40dbfd43f6678dc48f1549f"
    sha256 cellar: :any,                 sonoma:         "b25dbfd674e7e659c2524f35f97769626e222c48b8fda2fb1c2e412a0b9b5156"
    sha256 cellar: :any,                 ventura:        "b25dbfd674e7e659c2524f35f97769626e222c48b8fda2fb1c2e412a0b9b5156"
    sha256 cellar: :any,                 monterey:       "b25dbfd674e7e659c2524f35f97769626e222c48b8fda2fb1c2e412a0b9b5156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c0f6d967d9b72d0ef445175b7fc40f4610ae35d6e854a21095372af478948d"
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