class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.3.tgz"
  sha256 "d92f43674516f236fb173f778eff76d934ada7bd706ce9d2e0e0df03613181b0"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26e33233997821a3904e9ee115abbdaa4879818937561f594ebd020fb2b797b5"
    sha256 cellar: :any,                 arm64_sequoia: "93bada93790535c299764986564ba0b2715cbdf5a25fd9acbb252a0b8c29ee98"
    sha256 cellar: :any,                 arm64_sonoma:  "93bada93790535c299764986564ba0b2715cbdf5a25fd9acbb252a0b8c29ee98"
    sha256 cellar: :any,                 sonoma:        "1d22337f9715eab02f6686e7c71341b5c0b8bfd25e1ea072106de15881652bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08422cd3f27a3e70dcd94b0449e47b0a542d1da65e87b5513e029404def8cfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08422cd3f27a3e70dcd94b0449e47b0a542d1da65e87b5513e029404def8cfe3"
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