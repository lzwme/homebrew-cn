class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.2.tgz"
  sha256 "06e0108a4941de2d709e1c3bc841d3e90c45c6a26cecac76f62044fa02cac1a0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9355c71688fff08e9b9265bf31355ec560554086932e7271f0797713372fd90"
    sha256 cellar: :any,                 arm64_sequoia: "c882b2f70d3794253baac1ee94a44de01e16af65e5d6650176d54dc1c7c3939c"
    sha256 cellar: :any,                 arm64_sonoma:  "c882b2f70d3794253baac1ee94a44de01e16af65e5d6650176d54dc1c7c3939c"
    sha256 cellar: :any,                 sonoma:        "d0ad4dec02a004ccd2e49a0ae3a798732c4b64da6fca6d9033440f76cef4554c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1efb2d2ee489df886c569b6f89b6e12853a248d70e65cf645f1b0aa8c961d0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efb2d2ee489df886c569b6f89b6e12853a248d70e65cf645f1b0aa8c961d0eb"
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