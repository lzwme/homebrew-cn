require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.26.0.tgz"
  sha256 "1ea17c9d5b46116eccc633a78c6f57ef6dc7954eeb599c044112c03d11a300d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "313b3a7282fcdd181df45745b84b32e3ee0504f95faa8b89d9ab2647bb3a8974"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313b3a7282fcdd181df45745b84b32e3ee0504f95faa8b89d9ab2647bb3a8974"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313b3a7282fcdd181df45745b84b32e3ee0504f95faa8b89d9ab2647bb3a8974"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e1e88dcd0f6a801fc772585f292fb596bbccb6cd3ecfa34e5534dc10ad7fec6"
    sha256 cellar: :any_skip_relocation, ventura:        "2e1e88dcd0f6a801fc772585f292fb596bbccb6cd3ecfa34e5534dc10ad7fec6"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1e88dcd0f6a801fc772585f292fb596bbccb6cd3ecfa34e5534dc10ad7fec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313b3a7282fcdd181df45745b84b32e3ee0504f95faa8b89d9ab2647bb3a8974"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end