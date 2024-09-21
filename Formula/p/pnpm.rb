class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.11.0.tgz"
  sha256 "1c0e33f70e5df9eede84a357bdfa0b1f9dba6e58194628d48a1055756f553754"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b499da2091aee2650f0a8edbde0b6525a83d3b18498bd74a597305d472d34c8"
    sha256 cellar: :any,                 arm64_sonoma:  "0b499da2091aee2650f0a8edbde0b6525a83d3b18498bd74a597305d472d34c8"
    sha256 cellar: :any,                 arm64_ventura: "0b499da2091aee2650f0a8edbde0b6525a83d3b18498bd74a597305d472d34c8"
    sha256 cellar: :any,                 sonoma:        "b96dbf18091fb1a0931c1caa3ea35e2be44c77fca79234e8d3635c87561351ed"
    sha256 cellar: :any,                 ventura:       "b96dbf18091fb1a0931c1caa3ea35e2be44c77fca79234e8d3635c87561351ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62aa75bdf0632ef4754218b3ccbf18872d7357827f31d4e11ca57fea4020bb9"
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