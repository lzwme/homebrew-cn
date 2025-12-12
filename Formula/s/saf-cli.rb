class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.5.2.tgz"
  sha256 "e2d0b60b40400426872d56dce4c5823c2f37589768eba808f58e8690f90684ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffccc32174fe3b8fce3a312dc901ce9ddb508a7048fce976c2dc382993a1594f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d804537b800577862a9babf7a376c37c3dbf178d6ff532441802b3e506418c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4d804537b800577862a9babf7a376c37c3dbf178d6ff532441802b3e506418c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca791d63191c760491d6dab75e7d5868c3372425883b2623cea802e5a40642d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad82d74ccf02eea321130de8ba7113f4282434626e695c824a45929e7e49007e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad82d74ccf02eea321130de8ba7113f4282434626e695c824a45929e7e49007e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@mitre/saf/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end