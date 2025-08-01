class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.14.0.tgz"
  sha256 "297534e65d5842450539c1e8022c8831ab5e1fe2eb74664787a815519542d620"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd5ad7fe21cc164437de2be8c38905c93a8fd04c5101561786145fd8dfb57893"
    sha256 cellar: :any,                 arm64_sonoma:  "cd5ad7fe21cc164437de2be8c38905c93a8fd04c5101561786145fd8dfb57893"
    sha256 cellar: :any,                 arm64_ventura: "cd5ad7fe21cc164437de2be8c38905c93a8fd04c5101561786145fd8dfb57893"
    sha256 cellar: :any,                 sonoma:        "39959583460dfbb79071cb17e9b11a28150c46950cc92c15913ac4ec0e2885aa"
    sha256 cellar: :any,                 ventura:       "39959583460dfbb79071cb17e9b11a28150c46950cc92c15913ac4ec0e2885aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bdbf113a6e8c325b2686a924657b26f2589a2132154862b38119bc5c0f0ddad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bdbf113a6e8c325b2686a924657b26f2589a2132154862b38119bc5c0f0ddad"
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