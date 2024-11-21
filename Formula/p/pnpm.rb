class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.14.2.tgz"
  sha256 "06e65a4965baff6d6097f9c8f75c35f6d420974dbc03d775009056a69edfd271"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97a32de35ae67943fd9495b74a4d4515913c1936da9cca97e72570741be22ee5"
    sha256 cellar: :any,                 arm64_sonoma:  "97a32de35ae67943fd9495b74a4d4515913c1936da9cca97e72570741be22ee5"
    sha256 cellar: :any,                 arm64_ventura: "97a32de35ae67943fd9495b74a4d4515913c1936da9cca97e72570741be22ee5"
    sha256 cellar: :any,                 sonoma:        "3e0e38c6d86f20e016c5604c06017b3734c7b9e26421f1a4b2dac312788e29b0"
    sha256 cellar: :any,                 ventura:       "3e0e38c6d86f20e016c5604c06017b3734c7b9e26421f1a4b2dac312788e29b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0857d161b16c87a38b878331864684c419c8ddc84283a6043f833a735d2085b"
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