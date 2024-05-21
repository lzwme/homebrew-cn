require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.15.1.tgz"
  sha256 "0dfbd2ce53907d9c91cf5e9125d8f044b37657427cd30ba7b2df5e920e5e7078"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfad5cccd88cff7e23a07eaf11c510430619b9f84a6158f7c1ce6da74c0092cf"
    sha256 cellar: :any,                 arm64_ventura:  "8968952d9b5e80e008f387e0f6cf3f21c6b4d0215e13ceb2b26743301a7ec8e6"
    sha256 cellar: :any,                 arm64_monterey: "51910439d1f5c05dd6c238120bece68436f19f2e2bfa7b0e0fa483f69e842acf"
    sha256 cellar: :any,                 sonoma:         "7ed84ca91dc6136fde73795623a938cb54380f0a3c8fc9a782f4e59985f425f5"
    sha256 cellar: :any,                 ventura:        "ea284fe7700cc556986007bd011f157ef64bc7dfc4b393ace39339483a817f28"
    sha256 cellar: :any,                 monterey:       "2d68a4b9d530a81cf769d69b07c74943f17e61b7e89fc97a1ac01e03915a7134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714f1b1c533f4deed0fc972ed205167c8d818023c93c9f961fef6e1da6ad480e"
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