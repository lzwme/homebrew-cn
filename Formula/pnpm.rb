class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.8.tgz"
  sha256 "0adb3bba1a065896feb4406c489f83f09b5e0c61ce35cde42d5e7e57fae22b79"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b609bfd60776e2bdc34b315aede715ba9ba5261f5665daa45011ebb761374d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b609bfd60776e2bdc34b315aede715ba9ba5261f5665daa45011ebb761374d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b609bfd60776e2bdc34b315aede715ba9ba5261f5665daa45011ebb761374d3a"
    sha256 cellar: :any_skip_relocation, ventura:        "6848149d3c57c23e02719ce973bf344b0e11af978a6aa55443b4a227e06bff41"
    sha256 cellar: :any_skip_relocation, monterey:       "6848149d3c57c23e02719ce973bf344b0e11af978a6aa55443b4a227e06bff41"
    sha256 cellar: :any_skip_relocation, big_sur:        "59f8a07a138a2700e108824017b8b12693f1d871b386a228aa0dc0a87c92a29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b609bfd60776e2bdc34b315aede715ba9ba5261f5665daa45011ebb761374d3a"
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