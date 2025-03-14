class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.6.3.tgz"
  sha256 "bc1efe92ee4d40b1a7a644e5ca9e1855c5c5eafc6b1512f9017b31b9245419db"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1cda32f76b4836120e07290adde3e872955f813caa6db79fa170d6742d89845c"
    sha256 cellar: :any,                 arm64_sonoma:  "1cda32f76b4836120e07290adde3e872955f813caa6db79fa170d6742d89845c"
    sha256 cellar: :any,                 arm64_ventura: "1cda32f76b4836120e07290adde3e872955f813caa6db79fa170d6742d89845c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72be47d353ddecd228cd3c21c8d2605902726932e195558f66e243d5ecf1927"
    sha256 cellar: :any_skip_relocation, ventura:       "b72be47d353ddecd228cd3c21c8d2605902726932e195558f66e243d5ecf1927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf12fa9326d0531b081226d02dd442ec67b154b8f41852c1d36e8acc49e91dad"
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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end