class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.5.1.tgz"
  sha256 "7daa8c833a57746e7e07fae7abef795637cabb1984f55b848218e365c9999e2c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2ac53095502734ddb007b78841614b78fa48420229185ead2954f9f1c48a0e1"
    sha256 cellar: :any,                 arm64_sonoma:  "e2ac53095502734ddb007b78841614b78fa48420229185ead2954f9f1c48a0e1"
    sha256 cellar: :any,                 arm64_ventura: "e2ac53095502734ddb007b78841614b78fa48420229185ead2954f9f1c48a0e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6295afa23b84cca81b7a878cc973a0e7b81d45f783b95049be0a712037bc169"
    sha256 cellar: :any_skip_relocation, ventura:       "f6295afa23b84cca81b7a878cc973a0e7b81d45f783b95049be0a712037bc169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a12b08c47bb31d547c289281b41bd4807d7177a7ba86ce4de43bb0c224de9b5"
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