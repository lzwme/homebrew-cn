class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.11.0.tgz"
  sha256 "85ef2eff216a1ae90804c00c8dfbfa6685353644650d10906a893c05aedcd884"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b7bcd283f6466bafcd7c9ff4dfc71579a56758adae699e4d4a98ee6d169450c"
    sha256 cellar: :any,                 arm64_sequoia: "5d4ebe46416695d27404ae2cc191e2f2768a840cbc1f00c1bbeaba3111bb7666"
    sha256 cellar: :any,                 arm64_sonoma:  "5d4ebe46416695d27404ae2cc191e2f2768a840cbc1f00c1bbeaba3111bb7666"
    sha256 cellar: :any,                 sonoma:        "8561f7d9569783c5dbf8879ec5ee363c20782dee5e0337777f871cb5ea8bfd00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2655dcebfb27b04fc3d238ff2b77f559d93a7ff9f5b4f1c656b162c96869fbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2655dcebfb27b04fc3d238ff2b77f559d93a7ff9f5b4f1c656b162c96869fbc1"
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