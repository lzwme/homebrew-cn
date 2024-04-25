require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.2.tgz"
  sha256 "67d2fbe48197b47cce41a40b0086045a42c7ac500a1ba0abfda6527cd720ebcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfe80d01d2ef027ea164d0f32d3adb909986163e88557199ddd5c81ecefdde20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe80d01d2ef027ea164d0f32d3adb909986163e88557199ddd5c81ecefdde20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe80d01d2ef027ea164d0f32d3adb909986163e88557199ddd5c81ecefdde20"
    sha256 cellar: :any_skip_relocation, sonoma:         "d95e4a90717b9c5edca6ae9aacab99047a5276bfd6f3bcbcf28b569acf91fb14"
    sha256 cellar: :any_skip_relocation, ventura:        "d95e4a90717b9c5edca6ae9aacab99047a5276bfd6f3bcbcf28b569acf91fb14"
    sha256 cellar: :any_skip_relocation, monterey:       "d95e4a90717b9c5edca6ae9aacab99047a5276bfd6f3bcbcf28b569acf91fb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c77bef4f22f6161208d5c0ca0ec46daea88c01d2daa3b780a7dbcd75b9113d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end