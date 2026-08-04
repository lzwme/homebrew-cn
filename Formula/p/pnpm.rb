class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.20.0.tgz"
  sha256 "34e198cb1e43237517ecedfd31f9ae26a6c0a3e5366ce58a2d05f4b21fb5f19a"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97dcb3f4ac0fb551f4e4837643803f3604b4923509c35056a4c821e628ee5142"
    sha256 cellar: :any,                 arm64_sequoia: "97dcb3f4ac0fb551f4e4837643803f3604b4923509c35056a4c821e628ee5142"
    sha256 cellar: :any,                 arm64_sonoma:  "97dcb3f4ac0fb551f4e4837643803f3604b4923509c35056a4c821e628ee5142"
    sha256 cellar: :any,                 sonoma:        "215c1f7e8d4c196abbfaaa95734305bc998b533f7366703712f0a836369bec93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab411a30f226280cd88296002be1c3c8df24a2fa0a0c8162f244fb11f463358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab411a30f226280cd88296002be1c3c8df24a2fa0a0c8162f244fb11f463358"
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