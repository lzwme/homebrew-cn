class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.18.0.tgz"
  sha256 "29c35ca8d2a287988fdee3e0f36e07d9b93783f567b579b7fd5b798a4563dd81"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8d45fbeedd4cb0fc8800416ada200d3ca14030a14494e5c2f811a6a7a70b5d0"
    sha256 cellar: :any,                 arm64_sequoia: "f8d45fbeedd4cb0fc8800416ada200d3ca14030a14494e5c2f811a6a7a70b5d0"
    sha256 cellar: :any,                 arm64_sonoma:  "f8d45fbeedd4cb0fc8800416ada200d3ca14030a14494e5c2f811a6a7a70b5d0"
    sha256 cellar: :any,                 sonoma:        "b9340380338e8b634ec89bb421182179e1038a963298301a458e324c9805adb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e53113f6c310e94ad2df4739c55ee46781c110547836926e6774a356127a26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e53113f6c310e94ad2df4739c55ee46781c110547836926e6774a356127a26a"
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