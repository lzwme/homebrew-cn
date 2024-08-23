class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.8.0.tgz"
  sha256 "56a9e76b51796ca7f73b85e44cf83712862091f4d498c0ce4d5b7ecdc6ba18f7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22631f4c855229b9220d88b76d3a266dafc51517759ca9fe838e84e6506b271d"
    sha256 cellar: :any,                 arm64_ventura:  "22631f4c855229b9220d88b76d3a266dafc51517759ca9fe838e84e6506b271d"
    sha256 cellar: :any,                 arm64_monterey: "22631f4c855229b9220d88b76d3a266dafc51517759ca9fe838e84e6506b271d"
    sha256 cellar: :any,                 sonoma:         "a3f1329799bbaba1d4b8c36e91e69ffd15f9abfd77d26f80cec3a7b682649b70"
    sha256 cellar: :any,                 ventura:        "a3f1329799bbaba1d4b8c36e91e69ffd15f9abfd77d26f80cec3a7b682649b70"
    sha256 cellar: :any,                 monterey:       "a3f1329799bbaba1d4b8c36e91e69ffd15f9abfd77d26f80cec3a7b682649b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac5d912497a611bb3580c09d28aa6a428ffb3d2a604def7739c3db66a006513"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end