class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.5.1.tgz"
  sha256 "de7a5c1bed8301805183a87997fe1720cd5caefb57be838535a4bfc4a1596959"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a99a751ab3b24b40dea2a828f91b3b47833423da0a73963cdf542fe7a83c18c"
    sha256 cellar: :any,                 arm64_sequoia: "3b694898656e57017d85175fd156181ff0cfc63e9e593bc6dc7107868975b681"
    sha256 cellar: :any,                 arm64_sonoma:  "3b694898656e57017d85175fd156181ff0cfc63e9e593bc6dc7107868975b681"
    sha256 cellar: :any,                 sonoma:        "7b3e9029696938911a855ddf2418e99b06344cd5e5f492f47a6e0a488782e064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbd1f134f6b10d4922e7259efbd6dc5a2707bed9ad62be3a9a38656100494601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd1f134f6b10d4922e7259efbd6dc5a2707bed9ad62be3a9a38656100494601"
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