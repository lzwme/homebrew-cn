class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.21.0.tgz"
  sha256 "6f3df2197bd017a97f1af5eb9ab19a8cf1ae41bcc5917cf36d505bc9a83b9578"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "053c8a84799b913db87ded948272d7b2c86226e92317053be008147df94c8f67"
    sha256 cellar: :any,                 arm64_sequoia: "997385234474364995a5002e8b418315d97457284daa6303b1c377607b55558f"
    sha256 cellar: :any,                 arm64_sonoma:  "997385234474364995a5002e8b418315d97457284daa6303b1c377607b55558f"
    sha256 cellar: :any,                 sonoma:        "774a88e558c4fa41eadfd380ba79218f64bf4af176e44b51341ff5dd8fa405f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a771c9cfa24a6813b5c9ecba72c4ab37fcdf51caba989f5a44cebf917abccfae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a771c9cfa24a6813b5c9ecba72c4ab37fcdf51caba989f5a44cebf917abccfae"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

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