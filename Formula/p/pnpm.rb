class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.6.2.tgz"
  sha256 "20072a1f6edd17646ea9234bf32c42d563dad37b2973e97a2dde5c17774a824d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2e05a3c5fcaec767dde06b713961dd3075cd519ff0bc1cf3ee902910a6766dd"
    sha256 cellar: :any,                 arm64_sonoma:  "b2e05a3c5fcaec767dde06b713961dd3075cd519ff0bc1cf3ee902910a6766dd"
    sha256 cellar: :any,                 arm64_ventura: "b2e05a3c5fcaec767dde06b713961dd3075cd519ff0bc1cf3ee902910a6766dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1f7145fbfa36250543a4c3c28654eac1cd1eadfe68fd83a61d8e0348699777d"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f7145fbfa36250543a4c3c28654eac1cd1eadfe68fd83a61d8e0348699777d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b69d850dcf1992d3a016039ebddba26f06d34f2e4761fbf70f5608432dff365"
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