class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.0.tgz"
  sha256 "4e6c94042da1055c77fbc92d01ec013c05b21b92c08a5554cb61ee3398adedb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa07bc4e88002010c41d46081278add594a983a9b0e72a922b83384b212e6dd3"
    sha256 cellar: :any,                 arm64_sequoia: "86ee4b8c4d64b114ee2771059ef5a5d9e9e41ef84f3cd2f3e386c6b1ed8926ca"
    sha256 cellar: :any,                 arm64_sonoma:  "86ee4b8c4d64b114ee2771059ef5a5d9e9e41ef84f3cd2f3e386c6b1ed8926ca"
    sha256 cellar: :any,                 sonoma:        "45cf9d74dc13513f17986c2a11e9340e4004b99d40d240c31ecd148393e19864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d475d9601e233314ad4f43f1bbc6cffdd8aa4aaaa015250bf46fb33777d72ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d348077cfc69736492456d691b097b569250f6cb75df1d422b5a28fe1d45ef"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end