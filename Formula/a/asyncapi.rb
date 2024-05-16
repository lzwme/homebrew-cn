require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.14.0.tgz"
  sha256 "3f6012423f53eb4030e8173ef9ba3fcc33a62289c10fc3b6deb0f56359a3043e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4eaffc641efcb65a2e3ae46773326bbadbd67a216296442c2335dc967db66bc"
    sha256 cellar: :any,                 arm64_ventura:  "adf7009b46fb3ecdc4d2870c81bd4d18692450f104e65b9256776d76307fcd09"
    sha256 cellar: :any,                 arm64_monterey: "bdf2d378d0cbeaa3a9de0adc965d6b6d97f1c4dae9cca8152e3df2a354f796c9"
    sha256 cellar: :any,                 sonoma:         "91404b1540e1233de434dc0aa55606bdb26c59b8a2a3f07bcd79060a947b5a2f"
    sha256 cellar: :any,                 ventura:        "b140bc0bc85298824de936bd62b672aaa1bc1237474c637f66a658daed74bb7e"
    sha256 cellar: :any,                 monterey:       "193320e6654698e89096279c2a6ddedc94c8189549e35632a93f46557f05e1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b627514e3ee65e127631e761136d18c3188f9848eaf63da1009dee7cf1665f85"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end