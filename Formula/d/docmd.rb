class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.10.tgz"
  sha256 "f47273e55c2508b35e2ea374c974f055a54056cd261649f2533330d57353d9b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91ceb15584f840b3ea8ddd5e1ab93b8e20e4f7874ea3e6bdd96841e07a6b03d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e28410dd518e652001fa41e142846657ced69c623ef1f2270c50b6e395bb29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e28410dd518e652001fa41e142846657ced69c623ef1f2270c50b6e395bb29"
    sha256 cellar: :any_skip_relocation, sonoma:        "091a6840f30727b4b5bfd62a9c5028450e9e5c8e622f335a299b1f01dd6b03d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31ba0ae6aa2072eafcbb3f27aeb60124a9d9f4bc2974a10e990bda0170bd1341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ba0ae6aa2072eafcbb3f27aeb60124a9d9f4bc2974a10e990bda0170bd1341"
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