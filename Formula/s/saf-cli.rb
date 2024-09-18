class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.14.tgz"
  sha256 "cd98ffe341f620e2f5317b85fb1d7374bbc8c9ec11709505ba01c02346aa23f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c0b4dc5d09f43668c1f3c62c1db507f5dc67cf513ad758cb1cc89d8e3768d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0b4dc5d09f43668c1f3c62c1db507f5dc67cf513ad758cb1cc89d8e3768d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c0b4dc5d09f43668c1f3c62c1db507f5dc67cf513ad758cb1cc89d8e3768d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4f3bbe4291650d7fda251ca26db428c2944913d7dc9392c704b35cccfd7764e"
    sha256 cellar: :any_skip_relocation, ventura:       "f4f3bbe4291650d7fda251ca26db428c2944913d7dc9392c704b35cccfd7764e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c0b4dc5d09f43668c1f3c62c1db507f5dc67cf513ad758cb1cc89d8e3768d48"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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