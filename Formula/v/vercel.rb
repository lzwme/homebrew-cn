class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.25.0.tgz"
  sha256 "8c054b115289a0414188f7636ee7e0ff11301698186f6374df9440ab2191cdff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "729ddc21126aa70eb1e270fdb87a23bbb1b39dc5e5583dcb0d1ce9fe2400e70c"
    sha256 cellar: :any,                 arm64_tahoe:       "729ddc21126aa70eb1e270fdb87a23bbb1b39dc5e5583dcb0d1ce9fe2400e70c"
    sha256 cellar: :any,                 arm64_sequoia:     "729ddc21126aa70eb1e270fdb87a23bbb1b39dc5e5583dcb0d1ce9fe2400e70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "901c9c6f8b577ba4ee995fb6709a5d8fe1d30462d14e5df53116544cc608ad4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "22b0fcd41d205d1d83731f8c01fc307f580ac9d223c51c0bff8b8bedf82769a5"
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