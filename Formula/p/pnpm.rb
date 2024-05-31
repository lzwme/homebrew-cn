class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.1.4.tgz"
  sha256 "30a1801ac4e723779efed13a21f4c39f9eb6c9fbb4ced101bce06b422593d7c9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19a2e6abc88451ccc70ddff36507cffc019c137c40cb8d1c140e2cdaf9147cb0"
    sha256 cellar: :any,                 arm64_ventura:  "19a2e6abc88451ccc70ddff36507cffc019c137c40cb8d1c140e2cdaf9147cb0"
    sha256 cellar: :any,                 arm64_monterey: "19a2e6abc88451ccc70ddff36507cffc019c137c40cb8d1c140e2cdaf9147cb0"
    sha256 cellar: :any,                 sonoma:         "da8e9eaac0e3511c4ed9f45c2759263267c83aa99f29788631f223abe5902454"
    sha256 cellar: :any,                 ventura:        "da8e9eaac0e3511c4ed9f45c2759263267c83aa99f29788631f223abe5902454"
    sha256 cellar: :any,                 monterey:       "da8e9eaac0e3511c4ed9f45c2759263267c83aa99f29788631f223abe5902454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0500b81443a616716a6e10d990e50e4ba9c90b5c29222b90acac78d342b14c6"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

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