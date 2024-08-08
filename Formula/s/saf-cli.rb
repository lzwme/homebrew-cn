class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.10.tgz"
  sha256 "bef03fbccc6399ddc33a20664bf9e98a2e887994645358fed3699012687a49a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df6a847e71604570278ffa04b923b39e19ebaa75f39b5d8f038080b003690fab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6a847e71604570278ffa04b923b39e19ebaa75f39b5d8f038080b003690fab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df6a847e71604570278ffa04b923b39e19ebaa75f39b5d8f038080b003690fab"
    sha256 cellar: :any_skip_relocation, sonoma:         "62b653c8fb40599afe2357635aa1e96316f23bcfe8e18e73dd0be40857511180"
    sha256 cellar: :any_skip_relocation, ventura:        "62b653c8fb40599afe2357635aa1e96316f23bcfe8e18e73dd0be40857511180"
    sha256 cellar: :any_skip_relocation, monterey:       "62b653c8fb40599afe2357635aa1e96316f23bcfe8e18e73dd0be40857511180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6a847e71604570278ffa04b923b39e19ebaa75f39b5d8f038080b003690fab"
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