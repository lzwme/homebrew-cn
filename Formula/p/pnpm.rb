class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.1.0.tgz"
  sha256 "3ee53e914011ec7f1a6e3ab0c58b9a024a052bfe18295b23b68567d6a6a5ebcd"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1645e214eabd611f883f86f1772b45d9ca17e6cdffb073470f98f5724e24afb0"
    sha256 cellar: :any,                 arm64_sonoma:  "1645e214eabd611f883f86f1772b45d9ca17e6cdffb073470f98f5724e24afb0"
    sha256 cellar: :any,                 arm64_ventura: "1645e214eabd611f883f86f1772b45d9ca17e6cdffb073470f98f5724e24afb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6603ba7b5f13fbf54336428e574c3b2c7005fd29d9825ce6ae1cc8381503b8c3"
    sha256 cellar: :any_skip_relocation, ventura:       "6603ba7b5f13fbf54336428e574c3b2c7005fd29d9825ce6ae1cc8381503b8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7210f5861655f7a0a8f35f87a569cab22201b9f43ec97c3d0e72ee1e61ed881c"
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