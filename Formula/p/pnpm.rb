class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.4.1.tgz"
  sha256 "4b702887986995933d4300836b04d6d02a43bc72b52e4f7e93a4ca608b959197"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "696dceb6c87cf2202e43b4be70338e9141402bf29fa4ffb646c896862d9b92f7"
    sha256 cellar: :any,                 arm64_sonoma:  "696dceb6c87cf2202e43b4be70338e9141402bf29fa4ffb646c896862d9b92f7"
    sha256 cellar: :any,                 arm64_ventura: "696dceb6c87cf2202e43b4be70338e9141402bf29fa4ffb646c896862d9b92f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b430b97878d2053a4a83afe16d1fb28ab8162d1b580a79324f24785c154c12d4"
    sha256 cellar: :any_skip_relocation, ventura:       "b430b97878d2053a4a83afe16d1fb28ab8162d1b580a79324f24785c154c12d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd46c535ddc20472a9bda512b09c3066d886791b41f3961b6d48892adb4bb806"
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