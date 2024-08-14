class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.7.0.tgz"
  sha256 "b35018fbfa8f583668b2649e407922a721355cd81f61beeb4ac1d4258e585559"
  license "MIT"
  revision 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ca724caba6d488b0eea5435db19a8108348f6e13fc4332799bbd22a68afa4d9"
    sha256 cellar: :any,                 arm64_ventura:  "8ca724caba6d488b0eea5435db19a8108348f6e13fc4332799bbd22a68afa4d9"
    sha256 cellar: :any,                 arm64_monterey: "8ca724caba6d488b0eea5435db19a8108348f6e13fc4332799bbd22a68afa4d9"
    sha256 cellar: :any,                 sonoma:         "4dac39d25cc4bf1ad4e3d41c66408ec5271e862912aa6ee971d011605d4fb8d8"
    sha256 cellar: :any,                 ventura:        "4dac39d25cc4bf1ad4e3d41c66408ec5271e862912aa6ee971d011605d4fb8d8"
    sha256 cellar: :any,                 monterey:       "4dac39d25cc4bf1ad4e3d41c66408ec5271e862912aa6ee971d011605d4fb8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f68aa69240c0ee762432d32d3cdf3240bb670e886e4b227d9b497b6027c218c"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

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