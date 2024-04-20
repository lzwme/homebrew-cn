class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.4.tgz"
  sha256 "caa915eaae9d9aefccf50ee8aeda25a2f8684d8f9d5c6e367eaf176d97c1f89e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e0f64f87ffedbe527931b759248ef8445b16de916b43fcdb36b7877eea97492"
    sha256 cellar: :any,                 arm64_ventura:  "1e0f64f87ffedbe527931b759248ef8445b16de916b43fcdb36b7877eea97492"
    sha256 cellar: :any,                 arm64_monterey: "1e0f64f87ffedbe527931b759248ef8445b16de916b43fcdb36b7877eea97492"
    sha256 cellar: :any,                 sonoma:         "1dd5ae5dbb4b81ceed9ec2c1d294debab46136d3cfb2c714023966ba2fa37870"
    sha256 cellar: :any,                 ventura:        "1dd5ae5dbb4b81ceed9ec2c1d294debab46136d3cfb2c714023966ba2fa37870"
    sha256 cellar: :any,                 monterey:       "1dd5ae5dbb4b81ceed9ec2c1d294debab46136d3cfb2c714023966ba2fa37870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cfe2ddc99b0d890611fdb601a736ffaefcba8644dd3b9bc210a7b628641af31"
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