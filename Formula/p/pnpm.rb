class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.21.0.tgz"
  sha256 "87237d37eadb79dc626a0576eb3a52d23d70422c323ae5e00fc05c91f4323780"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d12e1f4a5ba1901fb13c56cfba751e1a60197e18b849bd352af6f8c89a8dc2c"
    sha256 cellar: :any,                 arm64_sequoia: "9d12e1f4a5ba1901fb13c56cfba751e1a60197e18b849bd352af6f8c89a8dc2c"
    sha256 cellar: :any,                 arm64_sonoma:  "9d12e1f4a5ba1901fb13c56cfba751e1a60197e18b849bd352af6f8c89a8dc2c"
    sha256 cellar: :any,                 sonoma:        "084c30d041753e64206a6bf847802bc13d82fd0938f5620a378d7e1aabab367a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85038899da1b2813314d23827f2b5f5eee24962903130541200c0a4070f638f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85038899da1b2813314d23827f2b5f5eee24962903130541200c0a4070f638f0"
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