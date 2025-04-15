class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.8.1.tgz"
  sha256 "d8b2ebbc65cf02c349eca6b45c9640b910f16b6adebdb7b926e9db440e47cac7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ea97d6d3f633e39a3bf458094751e3d9da2b43d80b46d4b8a861575b2dcc249"
    sha256 cellar: :any,                 arm64_sonoma:  "0ea97d6d3f633e39a3bf458094751e3d9da2b43d80b46d4b8a861575b2dcc249"
    sha256 cellar: :any,                 arm64_ventura: "0ea97d6d3f633e39a3bf458094751e3d9da2b43d80b46d4b8a861575b2dcc249"
    sha256 cellar: :any,                 sonoma:        "21eb25327b8baa45092b72f245de2f45ae9c61050060b9e6a703aa3ab817ed49"
    sha256 cellar: :any,                 ventura:       "21eb25327b8baa45092b72f245de2f45ae9c61050060b9e6a703aa3ab817ed49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a37859bc4046ee414b49db3ab7860b87b3a8ce199a0eed0870652275279b05ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37859bc4046ee414b49db3ab7860b87b3a8ce199a0eed0870652275279b05ec"
  end

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end