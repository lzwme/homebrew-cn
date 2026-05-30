class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.5.0.tgz"
  sha256 "a282871708f87a47b9cd72182dfdf9ee251c69100b8bac862a3d4f5e2145d8ff"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19074eb4f2f0bc75a439178da46c2ff0eeda89f8d378913b3b03f598d7a6ef18"
    sha256 cellar: :any,                 arm64_sequoia: "f99e3c78871d82e2d40922358f13ed5b808f26a4505c5ecb908a797d193136ac"
    sha256 cellar: :any,                 arm64_sonoma:  "f99e3c78871d82e2d40922358f13ed5b808f26a4505c5ecb908a797d193136ac"
    sha256 cellar: :any,                 sonoma:        "5ef9826689b7d720a8a58fea43288d1b4bdbde970ee150c662d5dad3afb372e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6ca517f93b02faac3d08386c575db4cf0303c77c62c6feb537948e5c2af1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6ca517f93b02faac3d08386c575db4cf0303c77c62c6feb537948e5c2af1b1"
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