class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.5.4.tgz"
  sha256 "dc1c18f649b9d2372c19aba68e2080a666510c1cf4b4fec0b683f7ce68518bb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "330830764256865c1998e650de3ec615354db43c0fb1e4dd12d3c82c6704a196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c1ebc28120dfd6c17da141c62d043843cfbf59b9fff716a7216706c53dfec88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c1ebc28120dfd6c17da141c62d043843cfbf59b9fff716a7216706c53dfec88"
    sha256 cellar: :any_skip_relocation, sonoma:        "075010f97dd13bf172ad317f957ae1d2aed10b2cdb60605845fb7073c10db1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a796a910d1219db56130bc732d6daf5766da2c874bc449425e2feff80173530c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a796a910d1219db56130bc732d6daf5766da2c874bc449425e2feff80173530c"
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