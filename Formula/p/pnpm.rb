class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.1.0.tgz"
  sha256 "573c82ad356e8b097e6cac481b7381f9deed33a318af7f311984858ebe1f97ef"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "439eafa9796194078715523ed1aa92c1dd9c05c71ad0bac9d75e995ca85c0803"
    sha256 cellar: :any,                 arm64_sequoia: "d8ed27d8a175343f0b091149d5e90735d7922596a056d718c3d0eac3cce3e55d"
    sha256 cellar: :any,                 arm64_sonoma:  "d8ed27d8a175343f0b091149d5e90735d7922596a056d718c3d0eac3cce3e55d"
    sha256 cellar: :any,                 sonoma:        "4af1dcc8f35fb339d51ea2950c0dd39bb9f3319756dea7e29a443b364f7dfb07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d8ea9dbc8473e1cdb5f8d9648b4d04beebef812bf73bce39a44562b6ef2037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54d8ea9dbc8473e1cdb5f8d9648b4d04beebef812bf73bce39a44562b6ef2037"
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