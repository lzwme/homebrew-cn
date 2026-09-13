class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.16.0.tgz"
  sha256 "58497b83da58f12722d8d5bbe4cd6b3965b918507899e459feea4af4a5717771"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "df80a6523011aab4dbce6050556240067bbd99678f622f985d3b0e91bdc5c566"
    sha256 cellar: :any,                 arm64_tahoe:       "df80a6523011aab4dbce6050556240067bbd99678f622f985d3b0e91bdc5c566"
    sha256 cellar: :any,                 arm64_sequoia:     "df80a6523011aab4dbce6050556240067bbd99678f622f985d3b0e91bdc5c566"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52ce343fb7b991ecb72fb38a3f9fcfdee24fa47aafa28df3f30641cd6dc6bc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9fd5fd9fb1f03594618fe1de3d4c45ed4387f7886443a1e1351cf8fc2e685ec1"
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