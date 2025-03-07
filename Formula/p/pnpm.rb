class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.6.0.tgz"
  sha256 "71ea235e611e2c8e6043ffca1c278f82089f71dfec4d1e9d01b47825e5e92f89"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ab2b285e8c491707ce43b7f52608c340337f1e0e951bc64a8bc8a0035682400"
    sha256 cellar: :any,                 arm64_sonoma:  "0ab2b285e8c491707ce43b7f52608c340337f1e0e951bc64a8bc8a0035682400"
    sha256 cellar: :any,                 arm64_ventura: "0ab2b285e8c491707ce43b7f52608c340337f1e0e951bc64a8bc8a0035682400"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8ceef951fa4b1bd7ec8ec4075d1d4d534c097a712143633470e93717034a0f"
    sha256 cellar: :any_skip_relocation, ventura:       "3a8ceef951fa4b1bd7ec8ec4075d1d4d534c097a712143633470e93717034a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e2c852f745ced979e1ce0dff9507ce739be0a60af2a71cba20683637f42fc8"
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