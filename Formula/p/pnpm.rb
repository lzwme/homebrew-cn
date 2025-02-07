class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.2.1.tgz"
  sha256 "f988f0d93b87e1da2d8cdf6ac7f45a01c6f843ae3606b4ca0f2ffd713b85f975"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "75abe53953f48e108fe65c10415ef251c2185afd37c7f5bddd31dd6c03fe0c1b"
    sha256 cellar: :any,                 arm64_sonoma:  "75abe53953f48e108fe65c10415ef251c2185afd37c7f5bddd31dd6c03fe0c1b"
    sha256 cellar: :any,                 arm64_ventura: "75abe53953f48e108fe65c10415ef251c2185afd37c7f5bddd31dd6c03fe0c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f59ef7d3419f4fe09680d41116dce7b9e109cf87430611be31f0b6f1a1b9fee"
    sha256 cellar: :any_skip_relocation, ventura:       "2f59ef7d3419f4fe09680d41116dce7b9e109cf87430611be31f0b6f1a1b9fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f8f7a16475e35498e6cf1e8dd60a825f38e34cc3b4d8f3e8c4e1da39e0e0e9"
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