class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.1.tgz"
  sha256 "9e534e70afef06374f6126b44bda5760947135ce16a30aef1010e965fb7e3e3e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "475db7977c15bfd9bb77c7ed47965d2bc7d3b683dbaabd91f97cb479d8eb2b2f"
    sha256 cellar: :any,                 arm64_sonoma:  "475db7977c15bfd9bb77c7ed47965d2bc7d3b683dbaabd91f97cb479d8eb2b2f"
    sha256 cellar: :any,                 arm64_ventura: "475db7977c15bfd9bb77c7ed47965d2bc7d3b683dbaabd91f97cb479d8eb2b2f"
    sha256 cellar: :any,                 sonoma:        "77b768f17ae00bf927ca01da2f4c898aa03dd20647c671ab6d50ad59c7a7888a"
    sha256 cellar: :any,                 ventura:       "77b768f17ae00bf927ca01da2f4c898aa03dd20647c671ab6d50ad59c7a7888a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989d4863d70e0e145f0d93f2de928bb8b67da1fefdb86944b43d3c8fc7fdc9bd"
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