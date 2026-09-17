class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.18.0.tgz"
  sha256 "42e8ba916373b2fa8c49994f4606d4527a6004296820939daa34380d5ed135c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "257ee6b5d82defc061005d95aeae3b8068afb2d760085923cc1e0b6094c5ac7c"
    sha256 cellar: :any,                 arm64_tahoe:       "257ee6b5d82defc061005d95aeae3b8068afb2d760085923cc1e0b6094c5ac7c"
    sha256 cellar: :any,                 arm64_sequoia:     "257ee6b5d82defc061005d95aeae3b8068afb2d760085923cc1e0b6094c5ac7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c5ec11b343a06e809f92f74266a34ac7985f569a24ab04f750c7106fd953b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4f9648bacc9b5457507d0b33df19542a65df6655952192b55468fc8ff9dfa321"
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