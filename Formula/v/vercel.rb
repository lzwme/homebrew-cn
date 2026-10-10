class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-63.1.0.tgz"
  sha256 "978d4393b222fd1cd8a9a94c8fb3c0e3ac4a0e1c0f9fa147bb521a87dfd124fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c74d5178df338d15d7559f49dbe9ecb2e766df80618fdebf928d26ac918fe002"
    sha256 cellar: :any,                 arm64_tahoe:       "c74d5178df338d15d7559f49dbe9ecb2e766df80618fdebf928d26ac918fe002"
    sha256 cellar: :any,                 arm64_sequoia:     "c74d5178df338d15d7559f49dbe9ecb2e766df80618fdebf928d26ac918fe002"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4da7c13aba30628818dc633840d59d1aedd0476715e4eaccf7d4a488412355f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bf4b399e413249713873f8a091487150125c494a09df1f6406795ecb932e7629"
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