class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.20.0.tgz"
  sha256 "47a3352808501b8d1ef20112273b6a5dcfa53d28a55bcce36d268e878bd6bfe9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5557eb8401211ee92409ab3c379019a593320125f14fd804fd8cc34e00e3d125"
    sha256 cellar: :any,                 arm64_sequoia: "af02a4669bb501714e445faa4ddc0e1931875b09077a518c7d2b48d3889b8010"
    sha256 cellar: :any,                 arm64_sonoma:  "af02a4669bb501714e445faa4ddc0e1931875b09077a518c7d2b48d3889b8010"
    sha256 cellar: :any,                 sonoma:        "36c2fcc22e457a393a72331c3766134267292f3981daa2d9b5d68d7d01ef4d91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f45c8ecc52bfddb3aa20edcc9406cf455b6fa8155cdd227a14c24b2a93b019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f45c8ecc52bfddb3aa20edcc9406cf455b6fa8155cdd227a14c24b2a93b019"
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