class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.6.4.tgz"
  sha256 "0a3574244b6d2bea5b5d530c0901fbc5dafa593c2e9962a421d57b839f97063f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07ce9e8dafdbe9aa8938cdf1f959da965cee5b129ab91a016de2a7d50f800ad6"
    sha256 cellar: :any,                 arm64_sonoma:  "07ce9e8dafdbe9aa8938cdf1f959da965cee5b129ab91a016de2a7d50f800ad6"
    sha256 cellar: :any,                 arm64_ventura: "07ce9e8dafdbe9aa8938cdf1f959da965cee5b129ab91a016de2a7d50f800ad6"
    sha256 cellar: :any_skip_relocation, sonoma:        "90cf17cbc2fad1a159fd7776586d20db19dd76a6ec60530454750f8e544e0779"
    sha256 cellar: :any_skip_relocation, ventura:       "90cf17cbc2fad1a159fd7776586d20db19dd76a6ec60530454750f8e544e0779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c51ad35f658a93a7548099a0f76621fc533434f4d617ddb2c6529ed0a4f78be"
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