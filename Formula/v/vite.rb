class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.0.tgz"
  sha256 "ba963c0ede5d2caf4eedf9bc4695578df019a3845c8c49b430b3b50b6a8948a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f82c3cec6a561038eaf055c4c9bb33762a39c6b4013584b040aab89e24e94ad"
    sha256 cellar: :any,                 arm64_sequoia: "5b6e08fb080f00ac1bfc7c3d27ebb147adfadc553aed4e62de114ac2ebcfe440"
    sha256 cellar: :any,                 arm64_sonoma:  "5b6e08fb080f00ac1bfc7c3d27ebb147adfadc553aed4e62de114ac2ebcfe440"
    sha256 cellar: :any,                 sonoma:        "1cf2b4c3efd8d84ae18a607beca101936c5df07821a0213e3e0c8d78a3839d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d285ddb831e968469b111143191f262469d392f4a47526e075d32b5233b6e3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361cd66f2016c67fe8217377db06df78ef107084c6cca27cd6d3dae7bc0124af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end