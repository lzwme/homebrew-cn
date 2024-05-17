require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.5.tgz"
  sha256 "b4889a846fd60d422b49d970c64cf56f6fa00d524c2e398757bbcd8ba7f37e5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ecc314aee5c72433e0fe22d0e5ee1e8234fedc60ef05de469befb5ef37258a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5495987440dc0e4fef496507820a42b9a567a4ffbbb96fb1858e1ae3f9ce085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1605b9df7582b482b308ad132ebbc9b7e899ef98813eddc60c7e220642365405"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac26567b0e0674e66594b74a639fb8accbcfb9f88280f8ca9cd6c06f47009ff0"
    sha256 cellar: :any_skip_relocation, ventura:        "4dfcc95789ccd25f701f711cddb5810137c7c838ba028d372cec0cced5858106"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e64b6b1851065849294bb25b77e55b3bfa0c86fe23ce23404252b07804e37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b36341a64dd61faf0d6f7175ea9a1368c5677a05e12ac422c42951a4be3e25"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end