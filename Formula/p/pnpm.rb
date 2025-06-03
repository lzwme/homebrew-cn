class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.11.1.tgz"
  sha256 "211e9990148495c9fc30b7e58396f7eeda83d9243eb75407ea4f8650fb161f7c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5d28430540ddaf80a867f5d21da6fb12c0b81413070b9ecead045584d1aa23b"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d28430540ddaf80a867f5d21da6fb12c0b81413070b9ecead045584d1aa23b"
    sha256 cellar: :any,                 arm64_ventura: "c5d28430540ddaf80a867f5d21da6fb12c0b81413070b9ecead045584d1aa23b"
    sha256 cellar: :any,                 sonoma:        "b6518c992901ef55534c6fb24d7d9a0897272df7951e1efd195f6bbda48693ca"
    sha256 cellar: :any,                 ventura:       "b6518c992901ef55534c6fb24d7d9a0897272df7951e1efd195f6bbda48693ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a04e2afaac80cc96e414e546310c45bc99c86672bdf6992b5e93515bb64b797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a04e2afaac80cc96e414e546310c45bc99c86672bdf6992b5e93515bb64b797"
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