class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.3.tgz"
  sha256 "c1da43727ccbc1ed42aff4fd6bdb4b1e91e65a818e6efff5b240fbf070ba4eaf"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e51e36734f36217f5e88edf34d05b76187e95b2a9a04110455e6a39f1c094515"
    sha256 cellar: :any,                 arm64_sonoma:  "e51e36734f36217f5e88edf34d05b76187e95b2a9a04110455e6a39f1c094515"
    sha256 cellar: :any,                 arm64_ventura: "e51e36734f36217f5e88edf34d05b76187e95b2a9a04110455e6a39f1c094515"
    sha256 cellar: :any,                 sonoma:        "3466d76ac687a7d374e8606621bcd0848b9248a43a2c98f57699a0a8d2c3db12"
    sha256 cellar: :any,                 ventura:       "3466d76ac687a7d374e8606621bcd0848b9248a43a2c98f57699a0a8d2c3db12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d422afed7a35b78c0fb5f538e2ec4bd09166dfd81d4d2a541b51abafee833757"
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