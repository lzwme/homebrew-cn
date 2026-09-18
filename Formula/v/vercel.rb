class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.20.0.tgz"
  sha256 "34c44a6a14200f9d9f0b2199195cf34a0e5ef2db241a65930324b692306838e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0091a290ccad85d6faa1ce1f92e6a7fce0191fc9c3142e0003ac19df8a7af732"
    sha256 cellar: :any,                 arm64_tahoe:       "0091a290ccad85d6faa1ce1f92e6a7fce0191fc9c3142e0003ac19df8a7af732"
    sha256 cellar: :any,                 arm64_sequoia:     "0091a290ccad85d6faa1ce1f92e6a7fce0191fc9c3142e0003ac19df8a7af732"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4502881560ecc1841799369f71f844ca8d67781c464a21771e55e624ead1e614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "af92dccdd8d1553e20cbe5a73a322b8cd0f4b007920edfef38e0973d3c746d60"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end