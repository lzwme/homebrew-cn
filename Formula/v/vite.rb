class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.4.tgz"
  sha256 "cf5c2d9bb7f9874ca48eae6b6401aab7a27d2080a574a28239aa69efae5de28c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d41a045336faab2e352ab84bf2759f681b43af55751088c6e1b3da9c3b126d3d"
    sha256 cellar: :any,                 arm64_sequoia: "21d3b4a47d422dafd278ed7794b617db86f9d4a663c0c44d3c0b7aff7323e3be"
    sha256 cellar: :any,                 arm64_sonoma:  "21d3b4a47d422dafd278ed7794b617db86f9d4a663c0c44d3c0b7aff7323e3be"
    sha256 cellar: :any,                 sonoma:        "780056ab47e0f6c4e9b9bed05a2036df7a380ea1248fd1ac42647d5a96b4c458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a4450e9f2b3b87287470eed1356f6b9d7b06b0cd3eba69096c17192548cffab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b2b7b857813560310edfbd0e1a02de4b773c83c6586eef2260956fc4610515"
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