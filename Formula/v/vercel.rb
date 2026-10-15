class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-64.0.2.tgz"
  sha256 "53107c64edea34049ac4d1e10b487e83e16f59cb55c42e9e102e33dd3d093977"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "54a06a51c2612e25a6d58dead99183c9d9c5304a0b9c98e8a2c21bab39125cd4"
    sha256 cellar: :any,                 arm64_tahoe:       "54a06a51c2612e25a6d58dead99183c9d9c5304a0b9c98e8a2c21bab39125cd4"
    sha256 cellar: :any,                 arm64_sequoia:     "54a06a51c2612e25a6d58dead99183c9d9c5304a0b9c98e8a2c21bab39125cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58f8c2ba555cbd2b756773083f64c701965d265380571994b0b15e0dd9aa6089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "53d784d128bfa6a2845b2be2731d7f1c6921804066b900d6e6aa197842cbd536"
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