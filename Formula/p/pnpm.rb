class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.13.0.tgz"
  sha256 "5cc43c266a7e1f28e35cb9e6b33694e424198d6d778e315b9c06313d2f6dab7b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0584d8246b2b6a46654f8d8d00cb3407fc4386c82ecc3ce6d310858ad6b7e63c"
    sha256 cellar: :any,                 arm64_sonoma:  "0584d8246b2b6a46654f8d8d00cb3407fc4386c82ecc3ce6d310858ad6b7e63c"
    sha256 cellar: :any,                 arm64_ventura: "0584d8246b2b6a46654f8d8d00cb3407fc4386c82ecc3ce6d310858ad6b7e63c"
    sha256 cellar: :any,                 sonoma:        "3bf676691753fbd239ee08c63f17d313c06df87b28bd7a5a84766237b2c7e717"
    sha256 cellar: :any,                 ventura:       "3bf676691753fbd239ee08c63f17d313c06df87b28bd7a5a84766237b2c7e717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218660cd37ea8a2e6da2953419e5e78e1bed8ee590cea79e8a676b36dde6023b"
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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end