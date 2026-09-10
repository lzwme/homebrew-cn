class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.12.0.tgz"
  sha256 "ab22d674f49873c8475d0ec2dd5aeef6e3306abdbc1f9a296d89fec3a11d1b52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42754e688aa4f38c754212048f7c3fc485cf2eb59f3327d924f48f3209f7bbc3"
    sha256 cellar: :any,                 arm64_sequoia: "42754e688aa4f38c754212048f7c3fc485cf2eb59f3327d924f48f3209f7bbc3"
    sha256 cellar: :any,                 arm64_sonoma:  "42754e688aa4f38c754212048f7c3fc485cf2eb59f3327d924f48f3209f7bbc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e93a9054e595700b8ead3d219d8c52b3594cff7eb63b5faf96b94cd6c86fb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b82dbc7a24394a1afd44bf18d9627e0a9ce6c0b0b5028de9dfe028f43daef6"
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