class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.11.tgz"
  sha256 "5cd03169778ef04c3eb7c10a71df860f923285085b3d4c26d3ee425ec0bb51e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fae939165b69a450212b997862d0f11215255002c8f57b5262f45abce6ca7405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88cf368bb9cece44787c9ee3557c8ccb64e0ef518b95bac22fcfdb6d5aec4750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88cf368bb9cece44787c9ee3557c8ccb64e0ef518b95bac22fcfdb6d5aec4750"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10164bcd410a9eef6471a84801b354cbd257676c2aa9c35bc4defcd12958778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5a107d26abbd426a2fcf05bf56687b5bcc180ae2e312f1559e97b7124d2dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5a107d26abbd426a2fcf05bf56687b5bcc180ae2e312f1559e97b7124d2dae"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end