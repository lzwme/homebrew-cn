class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.5.2.tgz"
  sha256 "79a98daa90248b50815e31460790f118c56fe099113370826caa0153be6daba5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef04634d6699224c71f96b65b21da285949e2c82a09a905efd20f6c6771b43b5"
    sha256 cellar: :any,                 arm64_sonoma:  "ef04634d6699224c71f96b65b21da285949e2c82a09a905efd20f6c6771b43b5"
    sha256 cellar: :any,                 arm64_ventura: "ef04634d6699224c71f96b65b21da285949e2c82a09a905efd20f6c6771b43b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8090ca6ef6341154c0f9d9ac4ede1cd554d73bd30ccc6737030ec957abacf49"
    sha256 cellar: :any_skip_relocation, ventura:       "a8090ca6ef6341154c0f9d9ac4ede1cd554d73bd30ccc6737030ec957abacf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4628fac252ceadbf54cca8ff103690d0e57ab1dd337e8b4e3d87b14acea27d"
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