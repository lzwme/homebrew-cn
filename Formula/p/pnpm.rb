class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.22.0.tgz"
  sha256 "053a8493e8e328a3c6d7ff5cb079bef28719152ccf831e4666b5c0332b77bb88"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2fca04a44a613c47d9ad3f3df7cd03c54bfd3299daebafcaea4b55bf18a13bc"
    sha256 cellar: :any,                 arm64_sequoia: "869e56c7ed75f63413070f19262cc819fced862882b483172bc67c56266ea50d"
    sha256 cellar: :any,                 arm64_sonoma:  "869e56c7ed75f63413070f19262cc819fced862882b483172bc67c56266ea50d"
    sha256 cellar: :any,                 sonoma:        "7431278f22382d3b40eb781358274f6b51340663697fad269c92749ca6ad89db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7330e168642241a1937726e99852c51cc41186056c045465a4c7cc8ec182bcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7330e168642241a1937726e99852c51cc41186056c045465a4c7cc8ec182bcb7"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

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