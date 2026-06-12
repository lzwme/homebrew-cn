class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.6.0.tgz"
  sha256 "a0162949d1ab19e12e8b3cd9f0f59ef02d7be74a28b806cf7f49fb7f4c07e5ce"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f892f0f84a90cc9c0cca4f9a2826aef30d070de2459b0d546fdcedfbcd386174"
    sha256 cellar: :any,                 arm64_sequoia: "2f5af20578ab8b6d98cf0391081a1f359142d4d068cad92475446036ea9a0b04"
    sha256 cellar: :any,                 arm64_sonoma:  "2f5af20578ab8b6d98cf0391081a1f359142d4d068cad92475446036ea9a0b04"
    sha256 cellar: :any,                 sonoma:        "0024641f06b1525d9944b64921b3d8e54b548bf3b35b63f62400c1169af0bb9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e9ab9b3dae41ada75e7bb95632a4046f4e760093faab83e6ee4858b3ee547e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9ab9b3dae41ada75e7bb95632a4046f4e760093faab83e6ee4858b3ee547e5"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
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