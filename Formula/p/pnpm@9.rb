class PnpmAT9 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.8.tgz"
  sha256 "03b251a61f54f0ebaf479ffe06df9e92742aa8b866070ee855ef679705a3a5ed"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-9"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65176d2f654c4a656f53da2497f11f753eb37b05cabe8a58e4d9616e1e987573"
    sha256 cellar: :any,                 arm64_sonoma:  "65176d2f654c4a656f53da2497f11f753eb37b05cabe8a58e4d9616e1e987573"
    sha256 cellar: :any,                 arm64_ventura: "65176d2f654c4a656f53da2497f11f753eb37b05cabe8a58e4d9616e1e987573"
    sha256 cellar: :any_skip_relocation, sonoma:        "820a41a36580fe36790327fb2d8540ae4a2de8732ed8fd6874b836f0c10b25f1"
    sha256 cellar: :any_skip_relocation, ventura:       "820a41a36580fe36790327fb2d8540ae4a2de8732ed8fd6874b836f0c10b25f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9427014676addd5d66ceb34010206f98c32f4022c0182831c232d4b76cf1b9b2"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@9"
    bin.install_symlink bin/"pnpx" => "pnpx@9"

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