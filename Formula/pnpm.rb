class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.0.0.tgz"
  sha256 "27707d3913a60cefbe63a1c1a057b1a98618f33e3f7e31cdcbdc811a61a101ad"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079f809bc3733f0da161072f9adf44307e0edce8e4d46e8d4ceab484d6f4249c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "079f809bc3733f0da161072f9adf44307e0edce8e4d46e8d4ceab484d6f4249c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "079f809bc3733f0da161072f9adf44307e0edce8e4d46e8d4ceab484d6f4249c"
    sha256 cellar: :any_skip_relocation, ventura:        "f10b72e3e8de787f487b9c9fe623ad2a186a5fef86d7852c7864fe833c55fb3a"
    sha256 cellar: :any_skip_relocation, monterey:       "f10b72e3e8de787f487b9c9fe623ad2a186a5fef86d7852c7864fe833c55fb3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6fbf3e2296eb07f167fd43aa554af80956ad2bb41e153f1a2f18aeed81d2da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079f809bc3733f0da161072f9adf44307e0edce8e4d46e8d4ceab484d6f4249c"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
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