class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.13.2.tgz"
  sha256 "ccce81bf7498c5f0f80e31749c1f8f03baba99d168f64590fc7e13fad3ea1938"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b018529e6baf800a0121bd6753e8aea0caff913d1a0feb4554afe26810736d97"
    sha256 cellar: :any,                 arm64_sonoma:  "b018529e6baf800a0121bd6753e8aea0caff913d1a0feb4554afe26810736d97"
    sha256 cellar: :any,                 arm64_ventura: "b018529e6baf800a0121bd6753e8aea0caff913d1a0feb4554afe26810736d97"
    sha256 cellar: :any,                 sonoma:        "e80188faad3a240180545cd10d43ccc2848cc64d43e2c20d08ddda8239d8a4d7"
    sha256 cellar: :any,                 ventura:       "e80188faad3a240180545cd10d43ccc2848cc64d43e2c20d08ddda8239d8a4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f53149058c40bdcc06f4a0058add10a72b4f4f7875fa868e21fb2f75bcf208ec"
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