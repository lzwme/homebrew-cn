class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.37.1.tgz"
  sha256 "3f0eecfa4868e1f170f746ecb2cd51cd00fb2eb0da46d2d5f8f8e26b630861b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0f3de066d0464b55d370b05d051345b6a3446c555c4d4aa93d7ee31fc1b756e"
    sha256 cellar: :any,                 arm64_sequoia: "c287e5768fb19a3057440ba881728ec89e85bf40afc6e9dae232c1981f97ddbc"
    sha256 cellar: :any,                 arm64_sonoma:  "c287e5768fb19a3057440ba881728ec89e85bf40afc6e9dae232c1981f97ddbc"
    sha256 cellar: :any,                 sonoma:        "9b5a8a55a85c7d07297d04bf8169fe4dce5bc5dc94b929bc4a9d38faf274eb18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b43c7013a01e528d130f83890f8602c5cf2081c82150ff4be23dc263133931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "017ebd92f92510472d6366e8d3c3d44955a5b1e22daaada3e128a1c864cbab5c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end