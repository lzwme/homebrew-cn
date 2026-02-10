class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.29.2.tgz"
  sha256 "8402f675a1f4cc9d4f27bbfab35c2d4a2e1d7eb0131df03dad09619e86674d0c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45ddab2facfd34aed065feebeddfe657a0c5f3dbd707314c884e3dc875c649c0"
    sha256 cellar: :any,                 arm64_sequoia: "d1cfef375464d19880708bce82d8a04c19105831a7c7551c62f6c8e2aac51abd"
    sha256 cellar: :any,                 arm64_sonoma:  "d1cfef375464d19880708bce82d8a04c19105831a7c7551c62f6c8e2aac51abd"
    sha256 cellar: :any,                 sonoma:        "182dd78066fde83b7d3359805dd898daf730d751b719fad2d2999d85a00965c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39f2a1a2546c8714d30dc3303fc4cc803a1dafe1c5fdf6951e6e6936c453a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39f2a1a2546c8714d30dc3303fc4cc803a1dafe1c5fdf6951e6e6936c453a44"
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