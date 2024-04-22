class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.5.tgz"
  sha256 "61bd66913b52012107ec25a6ee4d6a161021ab99e04f6acee3aa50d0e34b4af9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0af942f0fe7e501030fa8dc1ea82b1d7200ae5fa5e8ce94e39a60a937157c5d5"
    sha256 cellar: :any,                 arm64_ventura:  "0af942f0fe7e501030fa8dc1ea82b1d7200ae5fa5e8ce94e39a60a937157c5d5"
    sha256 cellar: :any,                 arm64_monterey: "0af942f0fe7e501030fa8dc1ea82b1d7200ae5fa5e8ce94e39a60a937157c5d5"
    sha256 cellar: :any,                 sonoma:         "c170ca9b474b0db7c167349fdb1952ab16f09efd89234ea02075434166ffc684"
    sha256 cellar: :any,                 ventura:        "c170ca9b474b0db7c167349fdb1952ab16f09efd89234ea02075434166ffc684"
    sha256 cellar: :any,                 monterey:       "c170ca9b474b0db7c167349fdb1952ab16f09efd89234ea02075434166ffc684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed580cf570bbe1c96b449f406489ffbe00355ceafc5605a45c8f1db07908b19b"
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