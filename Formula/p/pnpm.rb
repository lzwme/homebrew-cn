class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.14.4.tgz"
  sha256 "26a726b633b629a3fabda006f696ae4260954a3632c8054112d7ae89779e5f9a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00f40a4183072351ef266f7d2da70c1a330677aec6a0127889adf38d27bbc0a4"
    sha256 cellar: :any,                 arm64_sonoma:  "00f40a4183072351ef266f7d2da70c1a330677aec6a0127889adf38d27bbc0a4"
    sha256 cellar: :any,                 arm64_ventura: "00f40a4183072351ef266f7d2da70c1a330677aec6a0127889adf38d27bbc0a4"
    sha256 cellar: :any,                 sonoma:        "98dfb3dd27d86f35aa54b50d95ee7169896512189872dcf4aa4d3e61736410bc"
    sha256 cellar: :any,                 ventura:       "98dfb3dd27d86f35aa54b50d95ee7169896512189872dcf4aa4d3e61736410bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e2a52289fc55898609b330ca30939484d5e98f1e8c1ae13d65b2493b56bf87"
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