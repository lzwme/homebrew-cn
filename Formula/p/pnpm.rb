class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.12.1.tgz"
  sha256 "889bac470ec93ccc3764488a19d6ba8f9c648ad5e50a9a6e4be3768a5de387a3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fdfdfebd896ca3a78e601f99a23db1763b94a457e8726053c076f80030fda7b"
    sha256 cellar: :any,                 arm64_sonoma:  "5fdfdfebd896ca3a78e601f99a23db1763b94a457e8726053c076f80030fda7b"
    sha256 cellar: :any,                 arm64_ventura: "5fdfdfebd896ca3a78e601f99a23db1763b94a457e8726053c076f80030fda7b"
    sha256 cellar: :any,                 sonoma:        "34754eddf2d783d7e9bcaac1a24ff51def98e9c5bca9e90a50dbc9276315a914"
    sha256 cellar: :any,                 ventura:       "34754eddf2d783d7e9bcaac1a24ff51def98e9c5bca9e90a50dbc9276315a914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860c6a6638c26a9b5b61c6d955f9acc51c0c935e502888cfcc106b1d1e8559fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860c6a6638c26a9b5b61c6d955f9acc51c0c935e502888cfcc106b1d1e8559fa"
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