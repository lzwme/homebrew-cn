require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.12.0.tgz"
  sha256 "99d40407851428f6e0e6c6c64186e8f13a63f86eb5d17b6bf8c50ab4721eda77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b840a26e535114de85c7e0accc06b622df95cf0e0169ce53ae111ff0a308a067"
    sha256 cellar: :any,                 arm64_ventura:  "b840a26e535114de85c7e0accc06b622df95cf0e0169ce53ae111ff0a308a067"
    sha256 cellar: :any,                 arm64_monterey: "b840a26e535114de85c7e0accc06b622df95cf0e0169ce53ae111ff0a308a067"
    sha256 cellar: :any,                 sonoma:         "7f47713a0daeafac2e3d6bec63dc8768965d66f06d864edcac3061f2d5d4e101"
    sha256 cellar: :any,                 ventura:        "7f47713a0daeafac2e3d6bec63dc8768965d66f06d864edcac3061f2d5d4e101"
    sha256 cellar: :any,                 monterey:       "7f47713a0daeafac2e3d6bec63dc8768965d66f06d864edcac3061f2d5d4e101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112c331fc294f9f8b5f914d018c0ef5e03f4dd4d21f2db4f5e270e11dd8f9aff"
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