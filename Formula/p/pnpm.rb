class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.12.0.tgz"
  sha256 "a61b67ff6cc97af864564f4442556c22a04f2e5a7714fbee76a1011361d9b726"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "098029b79eaf539f67309c3777747ef420abd9f807dc592cf8470e7ef2383b7b"
    sha256 cellar: :any,                 arm64_sonoma:  "098029b79eaf539f67309c3777747ef420abd9f807dc592cf8470e7ef2383b7b"
    sha256 cellar: :any,                 arm64_ventura: "098029b79eaf539f67309c3777747ef420abd9f807dc592cf8470e7ef2383b7b"
    sha256 cellar: :any,                 sonoma:        "031b5b0331c13fa781a4ad24b3fbf641305bf44f4a4b4d76fe1a5f80bbd2ab8f"
    sha256 cellar: :any,                 ventura:       "031b5b0331c13fa781a4ad24b3fbf641305bf44f4a4b4d76fe1a5f80bbd2ab8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d2721356eb4b681af847a6c3f4529505a396c03782f43323fbf88fd58ddb2e"
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