class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.10.0.tgz"
  sha256 "3c5d70d07b0c4849d7e07398b62bf48ca6619ca86f77981125eaab7f5ee82c4c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5561590e58fad885bf2b67e099be0b0b61d35104dd3e7fc7bea5e6c35044e889"
    sha256 cellar: :any,                 arm64_ventura:  "5561590e58fad885bf2b67e099be0b0b61d35104dd3e7fc7bea5e6c35044e889"
    sha256 cellar: :any,                 arm64_monterey: "5561590e58fad885bf2b67e099be0b0b61d35104dd3e7fc7bea5e6c35044e889"
    sha256 cellar: :any,                 sonoma:         "110ea32b326ef4f6abdf7063e556068744896f7c7407bfec869b8e562fa4fc70"
    sha256 cellar: :any,                 ventura:        "110ea32b326ef4f6abdf7063e556068744896f7c7407bfec869b8e562fa4fc70"
    sha256 cellar: :any,                 monterey:       "110ea32b326ef4f6abdf7063e556068744896f7c7407bfec869b8e562fa4fc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a442a79951d7100a88881803b0d2df976cff3fca300924132644080c60826e69"
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