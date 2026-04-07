class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.5.tgz"
  sha256 "6a40fc494caab72c8e2a79bf7df3d535754aeb4f95cb81a8e0843360c8f7ba38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "536e7cec97af0288c91d85423160de32841f4065700022bcd3ac9b80368a78c4"
    sha256 cellar: :any,                 arm64_sequoia: "4e1824e74ed7ebecc4a2d70b986d6cd5f657b3ff9d47cdfab4852ecb3ff91f96"
    sha256 cellar: :any,                 arm64_sonoma:  "4e1824e74ed7ebecc4a2d70b986d6cd5f657b3ff9d47cdfab4852ecb3ff91f96"
    sha256 cellar: :any,                 sonoma:        "7063b9f03b16ece3b82999b3e2d5078037419385becfb30f96748a31e5d0bd3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ea6afcd2456e630d0fb088771393841a348e7e1d1607a8d120f05104d04891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b354313191b14661150b175d0452932fe0f5cb17c7214974a99bdb5fe4a117c0"
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