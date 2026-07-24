class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.17.0.tgz"
  sha256 "644eb5079654e87dae59a07e62d7f098162b9ce58f06077328b5ddefca1c8541"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "858393c7353489e21c6ad305ba44b56a46d83936ea4e2ac0d4923c5dc891aef8"
    sha256 cellar: :any,                 arm64_sequoia: "858393c7353489e21c6ad305ba44b56a46d83936ea4e2ac0d4923c5dc891aef8"
    sha256 cellar: :any,                 arm64_sonoma:  "858393c7353489e21c6ad305ba44b56a46d83936ea4e2ac0d4923c5dc891aef8"
    sha256 cellar: :any,                 sonoma:        "b58964ffc380217d756b79849d9320417aeb01b096c1da8c2696c026f954e8b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f5e721545959ce79bfbf1b3016c47b23f69abee23249c5ed3a159dae8ae8dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5e721545959ce79bfbf1b3016c47b23f69abee23249c5ed3a159dae8ae8dc8"
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