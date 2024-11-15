class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.13.1.tgz"
  sha256 "dd98691b127b5d2c4d0605b594e98ec0bcbe5fba86358184de706c3312a4e2ee"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c46bfdf27102721d1857587dae825440a5517999ea9f3566fdb5c9ac5151315"
    sha256 cellar: :any,                 arm64_sonoma:  "8c46bfdf27102721d1857587dae825440a5517999ea9f3566fdb5c9ac5151315"
    sha256 cellar: :any,                 arm64_ventura: "8c46bfdf27102721d1857587dae825440a5517999ea9f3566fdb5c9ac5151315"
    sha256 cellar: :any,                 sonoma:        "00fd084eaa03d41332460de21c8a4540b35ba67facc42a919ba38e2f6e607319"
    sha256 cellar: :any,                 ventura:       "00fd084eaa03d41332460de21c8a4540b35ba67facc42a919ba38e2f6e607319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43c05f398b64b6a4e58de2de0ff8c313ee99ead35a37998f9424dec0e8463b8"
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