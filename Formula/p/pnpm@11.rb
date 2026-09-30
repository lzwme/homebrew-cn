class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.28.2.tgz"
  sha256 "30d4099fa03b9ba1124d81527808b1e4d8e719aeb0ddfe169426df3c4a038a5f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8f5b46477f3664b13e323f1b6473bea8f6eb97dbff39c3faec8c796cf8a6e253"
    sha256 cellar: :any,                 arm64_tahoe:       "8f5b46477f3664b13e323f1b6473bea8f6eb97dbff39c3faec8c796cf8a6e253"
    sha256 cellar: :any,                 arm64_sequoia:     "8f5b46477f3664b13e323f1b6473bea8f6eb97dbff39c3faec8c796cf8a6e253"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b058c7abbf1391690c5ee2feaffc676cdfd996d6a304df09a41d1c6e6a389f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b058c7abbf1391690c5ee2feaffc676cdfd996d6a304df09a41d1c6e6a389f35"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  # downloads npm packages during install
  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@11"
    bin.install_symlink bin/"pnpx" => "pnpx@11"

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