class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.25.0.tgz"
  sha256 "33dd0748f27e7916c4f1c8b6943461983e3453b06bbda6312a6280130b4881e5"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any,                 arm64_sequoia: "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any,                 arm64_sonoma:  "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede465ac717deebdf76e2453a5cb263fd58d1563a91801259a5e7a71c22c3875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede465ac717deebdf76e2453a5cb263fd58d1563a91801259a5e7a71c22c3875"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  # downloads npm packages during install
  allow_network_access! :build

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