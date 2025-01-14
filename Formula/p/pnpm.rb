class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.4.tgz"
  sha256 "9bee59c7313a216722c079c1e22160dea7f88df4e0c3450b1d7b01b882336c6a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a10afa3c339a0fc7f92936a167856cf632c47302ef8101d564b62b16faa0a46a"
    sha256 cellar: :any,                 arm64_sonoma:  "a10afa3c339a0fc7f92936a167856cf632c47302ef8101d564b62b16faa0a46a"
    sha256 cellar: :any,                 arm64_ventura: "a10afa3c339a0fc7f92936a167856cf632c47302ef8101d564b62b16faa0a46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bcc403546c4993aa1e103032b488e722b5c2a027a3fb14d57e21aeab1d2d905"
    sha256 cellar: :any_skip_relocation, ventura:       "2bcc403546c4993aa1e103032b488e722b5c2a027a3fb14d57e21aeab1d2d905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207daa32472156e96ca1eb210490b678275f3fc33493f16019cdb6e8db8b8fc0"
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