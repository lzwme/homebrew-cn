class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.4.0.tgz"
  sha256 "ca9002efc0315a765c0e0ba01c52bd74e49f6683ff8763da06529976df52a992"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d512a160f8afc0ea340816fc0bb446205811f98c8eb600e26c7f45aa63792b68"
    sha256 cellar: :any,                 arm64_tahoe:       "d512a160f8afc0ea340816fc0bb446205811f98c8eb600e26c7f45aa63792b68"
    sha256 cellar: :any,                 arm64_sequoia:     "d512a160f8afc0ea340816fc0bb446205811f98c8eb600e26c7f45aa63792b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74c613643b61be28acb5c7bf6a00258e5f1ab8a8880b34bca1786b2d901ff222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "53de72ac4a2e284195039966b52f344699d000a5e9fc17a5bb8ad5874380d8d6"
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