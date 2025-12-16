class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.26.0.tgz"
  sha256 "f60974c68cfe0a13f951fba0199669588577f0e3f0c9b7d1a7ca47633bf72386"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c8412b051701e4f09eb95bd916695f344052f0026514ca3c014f892ed857e9a"
    sha256 cellar: :any,                 arm64_sequoia: "d1ebff842de963aa8a517651513d38e50812fc93f9992d832519a8740f8ce941"
    sha256 cellar: :any,                 arm64_sonoma:  "d1ebff842de963aa8a517651513d38e50812fc93f9992d832519a8740f8ce941"
    sha256 cellar: :any,                 sonoma:        "2fbb76b21cca146e34d05fa2604f93ff1d719148cd2670bdffa17e0647abb6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c5920003224ae6698b88309bcb4c178138fbf4733b54dfe14511c21ec16edc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5920003224ae6698b88309bcb4c178138fbf4733b54dfe14511c21ec16edc8"
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