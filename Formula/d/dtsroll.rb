class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.6.tgz"
  sha256 "f7ab77e54d130235e30a92f6af0dc9192bdba9ca5c11e06fadde4c2387da9c26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4837b44dc4d5c11f464431518de602944a87564cc0b04830551eab644a6eca00"
    sha256 cellar: :any,                 arm64_sequoia: "a745b09766cad696ce7fb74daa06c694f0dc1dc672e10550d2435d14af933fc4"
    sha256 cellar: :any,                 arm64_sonoma:  "a745b09766cad696ce7fb74daa06c694f0dc1dc672e10550d2435d14af933fc4"
    sha256 cellar: :any,                 sonoma:        "0621ecbb85e9bed66c660e5e1cf562ab2e730ce1e2f61a76ca11e383fb09d328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b008516009ac6fcad2866f9473e565d4755cee490013ee07ac72db85d42c9b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e54bf5f64f423df4233ef25f0485e848a5f314d8d6208dfa0f21606af9120ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end