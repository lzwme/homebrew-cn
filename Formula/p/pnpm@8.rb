class PnpmAT8 < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.7.tgz"
  sha256 "50783dd0fa303852de2dd1557cd4b9f07cb5b018154a6e76d0f40635d6cee019"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-8"
    regex(/["']version["']:\s*?["'](8[^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "849c0aa25de16f51ca7fcdeed19e163bcb0551b3dd4dc1bc9ee52ead756fbc34"
    sha256 cellar: :any,                 arm64_ventura:  "849c0aa25de16f51ca7fcdeed19e163bcb0551b3dd4dc1bc9ee52ead756fbc34"
    sha256 cellar: :any,                 arm64_monterey: "849c0aa25de16f51ca7fcdeed19e163bcb0551b3dd4dc1bc9ee52ead756fbc34"
    sha256 cellar: :any,                 sonoma:         "d2544ff56b3d13e34dd63854297421384c2659ad0398d2242121dae6d6473550"
    sha256 cellar: :any,                 ventura:        "d2544ff56b3d13e34dd63854297421384c2659ad0398d2242121dae6d6473550"
    sha256 cellar: :any,                 monterey:       "d2544ff56b3d13e34dd63854297421384c2659ad0398d2242121dae6d6473550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d2d5ba6f77a39ca8b682c5e914251da7c6b32e62698a54c6290186dccf0f13"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "node" => [:build, :test]

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm@8"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx@8"

    generate_completions_from_executable(bin/"pnpm@8", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm@8 requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm@8", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end