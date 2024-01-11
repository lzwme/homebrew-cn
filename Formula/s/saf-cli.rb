require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.3.2.tgz"
  sha256 "473d3e94e907f4cb49576d40d18b9f760c9e438eb4f721e9d38653741012cad8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba38d77489366f205b9c1e7891deec226e7699dded48f8215ffb7538255929ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba38d77489366f205b9c1e7891deec226e7699dded48f8215ffb7538255929ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba38d77489366f205b9c1e7891deec226e7699dded48f8215ffb7538255929ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "d89e7ccff9b0fd83f90e2cc2f23e798a0bc6500a7c13784746703c8e24176d8c"
    sha256 cellar: :any_skip_relocation, ventura:        "d89e7ccff9b0fd83f90e2cc2f23e798a0bc6500a7c13784746703c8e24176d8c"
    sha256 cellar: :any_skip_relocation, monterey:       "d89e7ccff9b0fd83f90e2cc2f23e798a0bc6500a7c13784746703c8e24176d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58137b03c1bdb78d002033bdaf1d04f44b8385f5b91d80a200b02fba22da03de"
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