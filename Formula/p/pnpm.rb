class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.6.tgz"
  sha256 "5cc39c9c736000c7a73d2807669a2c74fb94b37d125b9f794d898d28877053ca"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38390ba5a4b657c40642b0ba8b611396b732bb21aa1c84cd806df666ca79a6f7"
    sha256 cellar: :any,                 arm64_sequoia: "7b09c1be462b3b76df55ea0f4bd7af73ad5041f34de67935462c777f2829d291"
    sha256 cellar: :any,                 arm64_sonoma:  "7b09c1be462b3b76df55ea0f4bd7af73ad5041f34de67935462c777f2829d291"
    sha256 cellar: :any,                 sonoma:        "ba28540277b567e910c3a8e312116e1a8528b52d7104f810bade44ede7704f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "838aa14051571d6c367f6aaa3c862d2813ce380dc9ca2c545a029bd87c442bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "838aa14051571d6c367f6aaa3c862d2813ce380dc9ca2c545a029bd87c442bc7"
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