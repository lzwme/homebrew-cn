class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-60.1.3.tgz"
  sha256 "6dea7a09b1fd42bf289f1208c9e521e74da4d254ed944ae1dae4c65ccd2f16f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "95ab46892cd9ef6a166e36b4bd26bfc1e895ed82c4a75004ec034d438454486b"
    sha256 cellar: :any,                 arm64_tahoe:       "95ab46892cd9ef6a166e36b4bd26bfc1e895ed82c4a75004ec034d438454486b"
    sha256 cellar: :any,                 arm64_sequoia:     "95ab46892cd9ef6a166e36b4bd26bfc1e895ed82c4a75004ec034d438454486b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4c52b34e3e1727ef2f5f4807afabaa47291397ee2876a080547ea74aa8e9b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8bace56b07e699f7d20fcfec9e8b9084290fd896ba5fd2bb45f359cdc8c786f9"
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