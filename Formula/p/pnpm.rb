class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.7.1.tgz"
  sha256 "dc514890ea719003cb7a57d6b21af24fdafadd9f171e7567eca1665d7cfcef76"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8eeb12ca545e52a90a2dabe29dbac1384cbca5a391cca0cdb6512e6032689a31"
    sha256 cellar: :any,                 arm64_sonoma:  "8eeb12ca545e52a90a2dabe29dbac1384cbca5a391cca0cdb6512e6032689a31"
    sha256 cellar: :any,                 arm64_ventura: "8eeb12ca545e52a90a2dabe29dbac1384cbca5a391cca0cdb6512e6032689a31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6bd1769d0d265f0a78d1328331a0e1b19709b4db271c2b21f2c2a8b324cd3d"
    sha256 cellar: :any_skip_relocation, ventura:       "ba6bd1769d0d265f0a78d1328331a0e1b19709b4db271c2b21f2c2a8b324cd3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61602af885dee1a9d5d9113fa982a46aff1490fc1df55cb8b3e404ca2ceb90dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61602af885dee1a9d5d9113fa982a46aff1490fc1df55cb8b3e404ca2ceb90dd"
  end

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
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
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end