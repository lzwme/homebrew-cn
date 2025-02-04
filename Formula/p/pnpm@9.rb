class PnpmAT9 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.2.0.tgz"
  sha256 "72f1630812107c8723eb5be4517725f3e13f09cfd8f71571cf29f23ce318bdb7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-9"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf8f2d2fb95161e82fe9241cf5f08abfda36623efea0a74209a11a7d72f3db12"
    sha256 cellar: :any,                 arm64_sonoma:  "cf8f2d2fb95161e82fe9241cf5f08abfda36623efea0a74209a11a7d72f3db12"
    sha256 cellar: :any,                 arm64_ventura: "cf8f2d2fb95161e82fe9241cf5f08abfda36623efea0a74209a11a7d72f3db12"
    sha256 cellar: :any_skip_relocation, sonoma:        "8133f5b442e5c609e85ef8eb2aa66ac9ed25866d622453fd8912daa071abe295"
    sha256 cellar: :any_skip_relocation, ventura:       "8133f5b442e5c609e85ef8eb2aa66ac9ed25866d622453fd8912daa071abe295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d2f64275596905acb8fd3f01e18759eafde67e3490d902e28d6168476da632"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@9"
    bin.install_symlink bin/"pnpx" => "pnpx@9"

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