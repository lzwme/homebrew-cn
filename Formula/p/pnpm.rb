class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.14.1.tgz"
  sha256 "9978d5f40d4f376b054cf8c000cf8c326284344281e3c9bbf4e3d6f153b0e8de"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b58a5fe47e0f94dd81a00f10a439c5cf349b2b8501bc42aa4c34aa729c6aa147"
    sha256 cellar: :any,                 arm64_sonoma:  "b58a5fe47e0f94dd81a00f10a439c5cf349b2b8501bc42aa4c34aa729c6aa147"
    sha256 cellar: :any,                 arm64_ventura: "b58a5fe47e0f94dd81a00f10a439c5cf349b2b8501bc42aa4c34aa729c6aa147"
    sha256 cellar: :any,                 sonoma:        "38127b24a9f6e3bfcb06a7a83392721b2917f29f601f55594f712d5e6f1bff55"
    sha256 cellar: :any,                 ventura:       "38127b24a9f6e3bfcb06a7a83392721b2917f29f601f55594f712d5e6f1bff55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50393afa4a326936c19a6467e9d86a06e20135082bc7753e8f8a9708463ae00f"
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