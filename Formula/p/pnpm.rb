class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.7.0.tgz"
  sha256 "deafa7ec98a1218b6a047289b92fbe2395c1e22d3495bb711653013218ee15ee"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ab65e7493825a21549c35bd972852be5b336dbdee07c21f3e50b5b5d0525aab"
    sha256 cellar: :any,                 arm64_sequoia: "51f3d8d9003d9f5364d24b52e26d60aa3e5b9d651d2e542b87071dfc0849a253"
    sha256 cellar: :any,                 arm64_sonoma:  "51f3d8d9003d9f5364d24b52e26d60aa3e5b9d651d2e542b87071dfc0849a253"
    sha256 cellar: :any,                 sonoma:        "aa619587aac287a2b3d8eda20f933f733d83443573a42bf7a1e9f31ecad34432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ea06e760e59ff59ffa1a56fea1c84f5a8503dffc8b3057f0281e6548732924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ea06e760e59ff59ffa1a56fea1c84f5a8503dffc8b3057f0281e6548732924"
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