class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.1.2.tgz"
  sha256 "19c17528f9ca20bd442e4ca42f00f1b9808a9cb419383cd04ba32ef19322aba7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e31a6163521b96f092438cd7a1e1a97abfb82333260f423d6d63c2125c23b5b"
    sha256 cellar: :any,                 arm64_ventura:  "9e31a6163521b96f092438cd7a1e1a97abfb82333260f423d6d63c2125c23b5b"
    sha256 cellar: :any,                 arm64_monterey: "9e31a6163521b96f092438cd7a1e1a97abfb82333260f423d6d63c2125c23b5b"
    sha256 cellar: :any,                 sonoma:         "fe9e7330a023aaa085af219aedb81a2925790f8e1dff3148dfa22fadafde490c"
    sha256 cellar: :any,                 ventura:        "fe9e7330a023aaa085af219aedb81a2925790f8e1dff3148dfa22fadafde490c"
    sha256 cellar: :any,                 monterey:       "fe9e7330a023aaa085af219aedb81a2925790f8e1dff3148dfa22fadafde490c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b225c88b5d338f6843179432866377bbd51c147282fad808e3f134d530f1e0"
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