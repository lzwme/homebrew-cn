class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.19.0.tgz"
  sha256 "1c5f5ee59267e4e2e1bfd335f432a18dc48f9a9944094d5d2649757e725ad376"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "651dbb679201aad62ea8bc85197d36de3bb7c28967557350e810050de7d67237"
    sha256 cellar: :any,                 arm64_sequoia: "aae4cdf6c4aaf3e916247e7b0100327f25bbc194ce4a249c51ceca261b168557"
    sha256 cellar: :any,                 arm64_sonoma:  "aae4cdf6c4aaf3e916247e7b0100327f25bbc194ce4a249c51ceca261b168557"
    sha256 cellar: :any,                 sonoma:        "e8b8e6e86db3085e7e5a0050dba7065921aefa7c86615f759761e36d4beea27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2957876d88aeb912d8e6a0c1a55034f11249bcfe6c9be53d9622982779dbf95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2957876d88aeb912d8e6a0c1a55034f11249bcfe6c9be53d9622982779dbf95"
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