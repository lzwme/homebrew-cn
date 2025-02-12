class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.3.0.tgz"
  sha256 "24dd5c65d86c7d0710aba16699fbc46d74fc9acf2b419f4945207f2de9e57e23"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b72e7afeb956e9cda12278515e2ea9f2efac0d9842b6d3e2e9bafd7deb9fa972"
    sha256 cellar: :any,                 arm64_sonoma:  "b72e7afeb956e9cda12278515e2ea9f2efac0d9842b6d3e2e9bafd7deb9fa972"
    sha256 cellar: :any,                 arm64_ventura: "b72e7afeb956e9cda12278515e2ea9f2efac0d9842b6d3e2e9bafd7deb9fa972"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fda070ec9c8df731d051d044f4f6c1508ca043392e19133461c028fa2d5a5cd"
    sha256 cellar: :any_skip_relocation, ventura:       "1fda070ec9c8df731d051d044f4f6c1508ca043392e19133461c028fa2d5a5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1717764294303c8b70a52fbb56b508e5248cb845c8ecc22d9a798c7c57889add"
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