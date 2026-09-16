class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.17.0.tgz"
  sha256 "c2113ae1caf93d3a72154b1e6dcbd3ce7e1fe0c7efc4a507f0442abb96a1a57a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "af0ca17f72713d27b919eba7d718edf7f4c1640de1016af6bd551978d24311d8"
    sha256 cellar: :any,                 arm64_tahoe:       "af0ca17f72713d27b919eba7d718edf7f4c1640de1016af6bd551978d24311d8"
    sha256 cellar: :any,                 arm64_sequoia:     "af0ca17f72713d27b919eba7d718edf7f4c1640de1016af6bd551978d24311d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c10c97f42552c3d0088a66d9161a2c6aee201d3947cc9ac7ea6a0448b29d2142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "baaf37d853ac2bd68d9bd3af28f0dbc235ee1a3517861d5ec7e1d96b76867f9b"
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