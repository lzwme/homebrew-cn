class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.5.0.tgz"
  sha256 "e77bc3c5a9888f823fe061413f60ef02afad4b967c9b16b13458279473ba7d1c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57c61c5e1d81314d88455ad34198c7621722d879bdec280a18630bad45618452"
    sha256 cellar: :any,                 arm64_sonoma:  "57c61c5e1d81314d88455ad34198c7621722d879bdec280a18630bad45618452"
    sha256 cellar: :any,                 arm64_ventura: "57c61c5e1d81314d88455ad34198c7621722d879bdec280a18630bad45618452"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58ee0e33de5713cf56e688563263dc6159d43934f12fdc8801e95acab975547"
    sha256 cellar: :any_skip_relocation, ventura:       "c58ee0e33de5713cf56e688563263dc6159d43934f12fdc8801e95acab975547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2cf625b285e597b03e5d009ff63f1fbe1d26f1200f37a974b58ed2e5fc0549"
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