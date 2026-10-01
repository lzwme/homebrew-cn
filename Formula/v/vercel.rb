class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-61.1.0.tgz"
  sha256 "1b34c9253461ed44fe53655aa3dc3bff896998588e629f7483b912aa787e886a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fe3916ee45a9ceef793936c3855aec65b71c43f542b2d4cd0e73f10bc94292d1"
    sha256 cellar: :any,                 arm64_tahoe:       "fe3916ee45a9ceef793936c3855aec65b71c43f542b2d4cd0e73f10bc94292d1"
    sha256 cellar: :any,                 arm64_sequoia:     "fe3916ee45a9ceef793936c3855aec65b71c43f542b2d4cd0e73f10bc94292d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59aea733a3109c5315c67786bbe0110fb0d21debc845315b62999338e474dc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "605c8ad48167261be09aef1255bb73df2b0ee7cff02b355e92bcf42cc8ad58bc"
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