class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.3.tgz"
  sha256 "3e2a9063122a9b4991b336ca90163c820b8e8ac5f450fb3c9b0bd5694f94366f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7793df1a6f75bcfa5ccc27d56823563154ce2f7cb2856b297d87362937f4bdc8"
    sha256 cellar: :any,                 arm64_sequoia: "74ed4503ad6875435a1d75398da816ca05a3f36e7d5e843829427ecd32ace9a8"
    sha256 cellar: :any,                 arm64_sonoma:  "74ed4503ad6875435a1d75398da816ca05a3f36e7d5e843829427ecd32ace9a8"
    sha256 cellar: :any,                 sonoma:        "9f544635b995533dbf08451a493fe56ea080615f24307b8bb48654faed3e9c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7e1ee351dde54c1714918e774eed2a9b7f1765b7e3aadd5c8d2dfb008389ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7e1ee351dde54c1714918e774eed2a9b7f1765b7e3aadd5c8d2dfb008389ed"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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