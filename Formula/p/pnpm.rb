class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.0.1.tgz"
  sha256 "09f3b941fa1773927149ade7674f14e85bd5b4f9c71b5ada81bc4d316634883d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d22fb6f8b47d71d9cdceea5361ac3ae931228e90cb0dfc83bdfb39e8041968bb"
    sha256 cellar: :any,                 arm64_sequoia: "6c77d470e1a3f2edfaec5ae19e75e8d9f9c7fb890225e6ce1e83e96f4597de3c"
    sha256 cellar: :any,                 arm64_sonoma:  "6c77d470e1a3f2edfaec5ae19e75e8d9f9c7fb890225e6ce1e83e96f4597de3c"
    sha256 cellar: :any,                 sonoma:        "7034edf445c712c50fb508aed81eae18566de4e95daa22ff1f1c9e39602a12ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1a99cefcf0f32dbb43d536cf0cee67269bae10c5f7bc27116cea0d94f5d3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1a99cefcf0f32dbb43d536cf0cee67269bae10c5f7bc27116cea0d94f5d3db"
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