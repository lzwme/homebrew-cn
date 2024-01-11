class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.14.1.tgz"
  sha256 "2df78e65d433d7693b9d3fbdaf431b2d96bb4f96a2ffecd51a50efe16e50a6a8"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb012d90cd91f2863ef1b9847c4a5335b89643bfe54c0c38340315a180e19988"
    sha256 cellar: :any,                 arm64_ventura:  "cb012d90cd91f2863ef1b9847c4a5335b89643bfe54c0c38340315a180e19988"
    sha256 cellar: :any,                 arm64_monterey: "cb012d90cd91f2863ef1b9847c4a5335b89643bfe54c0c38340315a180e19988"
    sha256 cellar: :any,                 sonoma:         "a1d609f5360127571f38f60099c64877a7371d65933ab5df1fe709c107aa11a7"
    sha256 cellar: :any,                 ventura:        "a1d609f5360127571f38f60099c64877a7371d65933ab5df1fe709c107aa11a7"
    sha256 cellar: :any,                 monterey:       "a1d609f5360127571f38f60099c64877a7371d65933ab5df1fe709c107aa11a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29f911d1a5bf7ebdc480d2a48ebb1aba85d119bcc1b79e74d68996137f8bcb8"
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