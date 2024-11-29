class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.14.3.tgz"
  sha256 "652c47dac7c2b9350db4cdb9330c087d527114a0c2dff4cbac7ea9b96be928bd"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83ede034ae7ab2ea74995988b5337074b2e6ebaa2bed5266a71a42a00b70f45d"
    sha256 cellar: :any,                 arm64_sonoma:  "83ede034ae7ab2ea74995988b5337074b2e6ebaa2bed5266a71a42a00b70f45d"
    sha256 cellar: :any,                 arm64_ventura: "83ede034ae7ab2ea74995988b5337074b2e6ebaa2bed5266a71a42a00b70f45d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9924e25703054c9b62c229535674601273442dc157367d6f8a537236a9191667"
    sha256 cellar: :any_skip_relocation, ventura:       "9924e25703054c9b62c229535674601273442dc157367d6f8a537236a9191667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a96330c080ff13b9260ba98c7755ea704b92822f8412d5200224f9c86c0679b"
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