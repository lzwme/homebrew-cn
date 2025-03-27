class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.7.0.tgz"
  sha256 "35cab26953bf90847e798839db58c9a2a82d526b7af179fd2a103c18242cadc6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a43562d7dfd8eb751a6913548e6adb85b5e2debf918e51e655e67ee6e5e12a43"
    sha256 cellar: :any,                 arm64_sonoma:  "a43562d7dfd8eb751a6913548e6adb85b5e2debf918e51e655e67ee6e5e12a43"
    sha256 cellar: :any,                 arm64_ventura: "a43562d7dfd8eb751a6913548e6adb85b5e2debf918e51e655e67ee6e5e12a43"
    sha256 cellar: :any_skip_relocation, sonoma:        "8544b60b94883dd73b8a2e166f057b84cf9fefe4a2ebfba9ff61df3d36f1186d"
    sha256 cellar: :any_skip_relocation, ventura:       "8544b60b94883dd73b8a2e166f057b84cf9fefe4a2ebfba9ff61df3d36f1186d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8cec625645b0c3510cb5a4189d645b59b9c087db5dcbaf82b936a7a4436d09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8cec625645b0c3510cb5a4189d645b59b9c087db5dcbaf82b936a7a4436d09e"
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