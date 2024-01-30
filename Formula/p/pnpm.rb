class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.1.tgz"
  sha256 "245fe901f8e7fa8782d7f17d32b6a83995e2ae03984cb5b62b8949bfdc27c7b5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00e5c4883edfe97bf6cd3fdbae35944928a55de00dce11c04eafa550238621db"
    sha256 cellar: :any,                 arm64_ventura:  "00e5c4883edfe97bf6cd3fdbae35944928a55de00dce11c04eafa550238621db"
    sha256 cellar: :any,                 arm64_monterey: "00e5c4883edfe97bf6cd3fdbae35944928a55de00dce11c04eafa550238621db"
    sha256 cellar: :any,                 sonoma:         "7e45476e45e0be33d62d4ef57aee17b7f5aa9be929f71c64d366565de164ef3d"
    sha256 cellar: :any,                 ventura:        "7e45476e45e0be33d62d4ef57aee17b7f5aa9be929f71c64d366565de164ef3d"
    sha256 cellar: :any,                 monterey:       "7e45476e45e0be33d62d4ef57aee17b7f5aa9be929f71c64d366565de164ef3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a989c117eed1a84e262fa6a65944d005d5f6cd714eafdf626cd2562ecc036bb2"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

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