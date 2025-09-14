class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.16.1.tgz"
  sha256 "b77e92ba0d59a6372b6c5041bbb3f866fb85e927df333827f0c7f577c5e1a713"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d62792a37e959e389b0ed7a54224ded3506d6b4ff6b2de291561397578a052b4"
    sha256 cellar: :any,                 arm64_sequoia: "1bcd003a07b3cd3c272b1317b9a8cb72e9904f3ccd5de7b58bfd0ee39af20d77"
    sha256 cellar: :any,                 arm64_sonoma:  "1bcd003a07b3cd3c272b1317b9a8cb72e9904f3ccd5de7b58bfd0ee39af20d77"
    sha256 cellar: :any,                 sonoma:        "f35e79a74b2bca18a3b961d8af2bb9b6609144516f8fa8490552778cef8d0c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9fa0af0b94867adfbeb55f43744ed5b32db88815862a3731d11fab91948d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9fa0af0b94867adfbeb55f43744ed5b32db88815862a3731d11fab91948d92"
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