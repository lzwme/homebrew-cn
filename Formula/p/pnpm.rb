class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.1.1.tgz"
  sha256 "9551e803dcb7a1839fdf5416153a844060c7bce013218ce823410532504ac10b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cf40c5e7e7b51a8f8ba525ba85eb1654ec69f81f270586939ac3996a8393a30"
    sha256 cellar: :any,                 arm64_ventura:  "183f0d4c264ed61749ca0c0fb8bf03d82213d18c0480755fc8314f5cf2f3d982"
    sha256 cellar: :any,                 arm64_monterey: "fd66c0c18ce6f04143cc73378ed8685f89c2b87cc15b1facb7e46b05f119072e"
    sha256 cellar: :any,                 sonoma:         "7debbc13dbed25b8e6ef9e863b26da88fffa8a63161c7ed592ba3fdd690baef6"
    sha256 cellar: :any,                 ventura:        "89edd41ec9262f9b372e1413cb2f62243057662912309b580c4a045a01234572"
    sha256 cellar: :any,                 monterey:       "939d39316c31c7472b8763267f82cdbf004056b478104e1b176fcf55aefdad05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580ca23c4cbdcd9dbe6505daa88696eb1f643d2e459736f5ddefe5fb86a9dbab"
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