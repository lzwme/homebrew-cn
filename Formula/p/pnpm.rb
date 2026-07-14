class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.13.0.tgz"
  sha256 "865c76bd9111a45ca41f6eeed4067ff0ecdfee9eac83aad24179c83ffebe7599"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c12e8d14eb577a0f89357a2091c27dfa854feb29458ca9ea1212a0270958ec40"
    sha256 cellar: :any,                 arm64_sequoia: "3317929ba3eb126744eb7fb673475c765a98029767c563cc58a1ae06f20e309f"
    sha256 cellar: :any,                 arm64_sonoma:  "3317929ba3eb126744eb7fb673475c765a98029767c563cc58a1ae06f20e309f"
    sha256 cellar: :any,                 sonoma:        "7099f4bee47452f89c9ecce30512e65ca5c7edf2479c300c8dc4692880d0c19a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc055a87a5ebe3b03670beb2877f3b9ed7de7db1b1e69453b7d354a88d8d7905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc055a87a5ebe3b03670beb2877f3b9ed7de7db1b1e69453b7d354a88d8d7905"
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