class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.3.0.tgz"
  sha256 "5ade1ef51cf36441f4a00931eaf9003654689eba3684939f70d7576b2dfb8474"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37666e6e1576d452db3321af8f1a5cad559a7572d8415ea9585e73758b2d782a"
    sha256 cellar: :any,                 arm64_sequoia: "be935d18c69d75b59c506f5e26fa0c391c93eb309d38bee09278386b5f85e3b5"
    sha256 cellar: :any,                 arm64_sonoma:  "be935d18c69d75b59c506f5e26fa0c391c93eb309d38bee09278386b5f85e3b5"
    sha256 cellar: :any,                 sonoma:        "020cc15449c276fcb72f37932dc721c2033eb6b79be54f0241efc29e4dfe0d71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff4a8d20bffe1e62fd002aa01aa2d6f5a18d2cfc478d58d3e5d01ff027dc2f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4a8d20bffe1e62fd002aa01aa2d6f5a18d2cfc478d58d3e5d01ff027dc2f8c"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
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