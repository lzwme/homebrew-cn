class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.7.0.tgz"
  sha256 "b5afba8bce08e0317e27873628e0d9316a22c0fa2fdfe217d59f724b48e0723b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a5e7d3749108fb095a30a0853cd09bb19d424afd725886f09e57f1c98ccb4842"
    sha256 cellar: :any,                 arm64_tahoe:       "a5e7d3749108fb095a30a0853cd09bb19d424afd725886f09e57f1c98ccb4842"
    sha256 cellar: :any,                 arm64_sequoia:     "a5e7d3749108fb095a30a0853cd09bb19d424afd725886f09e57f1c98ccb4842"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "927c307ce2d77c063242833609dc15f80c30130d263d04cdf1e0cf0cc4e20008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ddc55b48b4e32b893d2b784cf07d40999c8ecbaaac649b5c532a305fd0656aa7"
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