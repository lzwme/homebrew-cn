class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.4.0.tgz"
  sha256 "b6fd0bfda555e7e584ad7e56b30c68b01d5a04f9ee93989f4b93ca8473c49c74"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "499288b8c5bffb275466bcf806d4a1a9f27ef96c1ed45fc2691271737c28a87f"
    sha256 cellar: :any,                 arm64_ventura:  "499288b8c5bffb275466bcf806d4a1a9f27ef96c1ed45fc2691271737c28a87f"
    sha256 cellar: :any,                 arm64_monterey: "499288b8c5bffb275466bcf806d4a1a9f27ef96c1ed45fc2691271737c28a87f"
    sha256 cellar: :any,                 sonoma:         "3d49d42be87ce556e2b66abd042907ab0fcf8c915c1ef237f49d4175bafcdc7d"
    sha256 cellar: :any,                 ventura:        "3d49d42be87ce556e2b66abd042907ab0fcf8c915c1ef237f49d4175bafcdc7d"
    sha256 cellar: :any,                 monterey:       "3d49d42be87ce556e2b66abd042907ab0fcf8c915c1ef237f49d4175bafcdc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088aa545e3e899d9f04b6a8b530d06fb82f26b42cffd21f6600e50b5f71148b1"
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