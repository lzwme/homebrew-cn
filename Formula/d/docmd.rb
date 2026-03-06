class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.5.0.tgz"
  sha256 "c9cc2c936b41decc38edc5b58cf6293aa67eae03601014d8487db3d222b9b6e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbff27bdfc17fe4f6eadbc6b151e5aa49e14a9c9e606fc083707e2293b77bceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190148d560697d1700f03ce1b49d6a418ec76dd24b2a95d4bc34ba24b28624e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190148d560697d1700f03ce1b49d6a418ec76dd24b2a95d4bc34ba24b28624e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b3ed79d08f85ce895ff676fbedb2f29680a17895df1e078fc6310e4072bcc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64400fdb1e3d9a5b366f6f9ac7f1208ee96aa17bdcc1595c00b75f5c3951dc88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64400fdb1e3d9a5b366f6f9ac7f1208ee96aa17bdcc1595c00b75f5c3951dc88"
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