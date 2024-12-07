class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.0.tgz"
  sha256 "09a8fe31a34fda706354680619f4002f4ccef6dadff93240d24ef6c831f0fd28"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8707fab5ae5e67b798e98955e2b49214ce09b015cc140b8c5582e693fa36c6e2"
    sha256 cellar: :any,                 arm64_sonoma:  "8707fab5ae5e67b798e98955e2b49214ce09b015cc140b8c5582e693fa36c6e2"
    sha256 cellar: :any,                 arm64_ventura: "8707fab5ae5e67b798e98955e2b49214ce09b015cc140b8c5582e693fa36c6e2"
    sha256 cellar: :any,                 sonoma:        "83af07ded720ba3d461bea946914d0e121a409ce442a70ef2b484877bf4196f9"
    sha256 cellar: :any,                 ventura:       "83af07ded720ba3d461bea946914d0e121a409ce442a70ef2b484877bf4196f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d210e389b50db10d7694338f423261337985d36e13ac42e66e175e79e64e8d"
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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end