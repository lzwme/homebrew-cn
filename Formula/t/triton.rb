require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.16.0.tgz"
  sha256 "e2e0eaa207a0821f6e79a0c06dfca9353ae2381def1ab4366f9914abfeeb47cb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76878591a179855e7abf9f0f5a61be99f8d2437f78db78264f674829e1660005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9db3df1fd23826896453bae9bd8b4efc9a6166608c5c28253760f5605948d1b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01286d33dda7aa56f27e1d3c33ac3ca2fd6ab1b769e6e6f47d0c712ce9f865e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "72728242c77350d45dbf294ea15557af027b43ef42ef1c5d7c144f622a516953"
    sha256 cellar: :any_skip_relocation, ventura:        "f696903227659f6220a2a6e0f289be509bb086d23530964623ec1b5b97b2833d"
    sha256 cellar: :any_skip_relocation, monterey:       "751122f7b462f379d687ddaf37c7ca30eb70f7764a18807e1ade2d82ae956f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba81f7ff6f01053ee8472429a927d431a99545d5a0da44236943ba1d7a9a551"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    generate_completions_from_executable(bin/"triton", "completion", shells: [:bash], shell_parameter_format: :none)
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end