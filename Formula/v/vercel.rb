class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.25.2.tgz"
  sha256 "089fc70f87b9a4fc92e8e0227706ce0a205872cf144634ba15a52321d2c36c37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e02c650c8dac16d3b7161a87d7a3dcf2169523a325a555b996fda1af2288927e"
    sha256 cellar: :any,                 arm64_tahoe:       "e02c650c8dac16d3b7161a87d7a3dcf2169523a325a555b996fda1af2288927e"
    sha256 cellar: :any,                 arm64_sequoia:     "e02c650c8dac16d3b7161a87d7a3dcf2169523a325a555b996fda1af2288927e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed6008663c3e17199e4c6b1586579a5f0d74b5cb9244542e095e188239c24a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d818fffe3fbca2131733232fefa999f0ef2027474c7513c8cdabb5507b22bcaa"
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