class PnpmAT11 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.28.8.tgz"
  sha256 "02bf6cec47fe28f30a224204f924175c2d8750c60e84e315a25cba57ce84da6a"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "417d3e6a6f981ee16bf489220faa45825e24babf93c31712661538c3ffff2d1d"
    sha256 cellar: :any,                 arm64_tahoe:       "417d3e6a6f981ee16bf489220faa45825e24babf93c31712661538c3ffff2d1d"
    sha256 cellar: :any,                 arm64_sequoia:     "417d3e6a6f981ee16bf489220faa45825e24babf93c31712661538c3ffff2d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e50b0cb65934d713fc8029fb832155b75fb3c95bfd6627aeb4effab1d48fd8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e50b0cb65934d713fc8029fb832155b75fb3c95bfd6627aeb4effab1d48fd8ce"
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