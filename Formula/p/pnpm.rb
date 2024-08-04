class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.6.0.tgz"
  sha256 "dae0f7e822c56b20979bb5965e3b73b8bdabb6b8b8ef121da6d857508599ca35"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8630463e5b5a84aeec092cee88c594aab35a599a388626c1fb1a5e6391545fa3"
    sha256 cellar: :any,                 arm64_ventura:  "8630463e5b5a84aeec092cee88c594aab35a599a388626c1fb1a5e6391545fa3"
    sha256 cellar: :any,                 arm64_monterey: "8630463e5b5a84aeec092cee88c594aab35a599a388626c1fb1a5e6391545fa3"
    sha256 cellar: :any,                 sonoma:         "c4894a1b8fe3e1738d8b6622ba9ccc237b4db0f25a1fb0696454d12845d93186"
    sha256 cellar: :any,                 ventura:        "c4894a1b8fe3e1738d8b6622ba9ccc237b4db0f25a1fb0696454d12845d93186"
    sha256 cellar: :any,                 monterey:       "c4894a1b8fe3e1738d8b6622ba9ccc237b4db0f25a1fb0696454d12845d93186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27dcfff31395db4ea188f31ea3d16a379b4a86a5b30b3b7d476886d1c01de8c7"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  skip_clean "bin"

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