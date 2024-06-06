class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.2.0.tgz"
  sha256 "94fab213df221c55b6956b14a2264c21c6203cca9f0b3b95ff2fe9b84b120390"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3a42447276d5269ffab6df76c0a5e715fbb85f8470993ad1903906020a4b157"
    sha256 cellar: :any,                 arm64_ventura:  "a3a42447276d5269ffab6df76c0a5e715fbb85f8470993ad1903906020a4b157"
    sha256 cellar: :any,                 arm64_monterey: "a3a42447276d5269ffab6df76c0a5e715fbb85f8470993ad1903906020a4b157"
    sha256 cellar: :any,                 sonoma:         "861cefe9ab64ea31cb15537b35bf420b6bc039f705b68d59d60f9c132fdda993"
    sha256 cellar: :any,                 ventura:        "861cefe9ab64ea31cb15537b35bf420b6bc039f705b68d59d60f9c132fdda993"
    sha256 cellar: :any,                 monterey:       "45520687e1564585e8cee3d79508fb2e38a9ed3bdafd30f73740e2eb6075405e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a55b3d51b67ed87f58ebe0805ee20ea91781b805e2781bb728e132c094b9ab"
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