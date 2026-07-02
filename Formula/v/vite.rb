class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.2.tgz"
  sha256 "97d0dd1791d040a68fe198309d3701e14e2cf9693d1e019ad99e51fee96852cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b69a3048b996011ac893b9625d5345c1c61743539f8338d1d2fec9053114f2d1"
    sha256 cellar: :any,                 arm64_sequoia: "776b516667457b137543e1f107aabb3c16d7a72948d3b4ace81a39d160e5ea51"
    sha256 cellar: :any,                 arm64_sonoma:  "776b516667457b137543e1f107aabb3c16d7a72948d3b4ace81a39d160e5ea51"
    sha256 cellar: :any,                 sonoma:        "6990c7d51bda380bd58227894db6b7e412d8e8ae64597e2f4bec4010cac876a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bd8670ddc8e14c449f5965df6fc5feaaac955cb8280a575fda3c49389058d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4746a7d05cde584ae937fe5e0582dac122f7377504064c91e64e17c08501e7ad"
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