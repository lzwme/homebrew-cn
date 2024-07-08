class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.5.0.tgz"
  sha256 "dbdf5961c32909fb030595a9daa1dae720162e658609a8f92f2fa99835510ca5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcc2c6845cdb6109aaa6a28e81c1f4915b419ad4eb04971bd472aeefe64496c1"
    sha256 cellar: :any,                 arm64_ventura:  "dcc2c6845cdb6109aaa6a28e81c1f4915b419ad4eb04971bd472aeefe64496c1"
    sha256 cellar: :any,                 arm64_monterey: "dcc2c6845cdb6109aaa6a28e81c1f4915b419ad4eb04971bd472aeefe64496c1"
    sha256 cellar: :any,                 sonoma:         "d92232e35e03b1605789413f7ded81276a8934be14c9ac3219a6ba9a40781024"
    sha256 cellar: :any,                 ventura:        "d92232e35e03b1605789413f7ded81276a8934be14c9ac3219a6ba9a40781024"
    sha256 cellar: :any,                 monterey:       "d92232e35e03b1605789413f7ded81276a8934be14c9ac3219a6ba9a40781024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8606afd2cbcb42e7313a3711bf367396e347a8e7d49798ee0380f3cafb24c61"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
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
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end