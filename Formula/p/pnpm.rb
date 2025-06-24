class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.12.2.tgz"
  sha256 "07b2396c6c99a93b75b5f9ce22be9285c3b2533c49fec51b349d44798cf56b82"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dda8faa9134d3ef47c97394c84be3864e37d086d390794ea4c67011b2f6891c0"
    sha256 cellar: :any,                 arm64_sonoma:  "dda8faa9134d3ef47c97394c84be3864e37d086d390794ea4c67011b2f6891c0"
    sha256 cellar: :any,                 arm64_ventura: "dda8faa9134d3ef47c97394c84be3864e37d086d390794ea4c67011b2f6891c0"
    sha256 cellar: :any,                 sonoma:        "7012f0ed1279721407877de8946d3010af5670d4a53b7e359a7f3d1b75c652e1"
    sha256 cellar: :any,                 ventura:       "7012f0ed1279721407877de8946d3010af5670d4a53b7e359a7f3d1b75c652e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd90171ec13e78fea1e4c16939a9dab1a4911feb852fc4d76c9123e012292d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd90171ec13e78fea1e4c16939a9dab1a4911feb852fc4d76c9123e012292d5d"
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