class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.106.tgz"
  sha256 "fc67c2828539ab5b757b37c01493cdd499170329d3d91c3f91ab715eedad818f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9fbc3f107a9c3944bf99b58ff71dc3fc05f8badc1048c1216d906111ada561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9fbc3f107a9c3944bf99b58ff71dc3fc05f8badc1048c1216d906111ada561"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a9fbc3f107a9c3944bf99b58ff71dc3fc05f8badc1048c1216d906111ada561"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac00362bcdc8e8f3184b66f82a2a51d40e3861a1463cb33ebcb2142b38d96d01"
    sha256 cellar: :any_skip_relocation, ventura:       "ac00362bcdc8e8f3184b66f82a2a51d40e3861a1463cb33ebcb2142b38d96d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a9fbc3f107a9c3944bf99b58ff71dc3fc05f8badc1048c1216d906111ada561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9fbc3f107a9c3944bf99b58ff71dc3fc05f8badc1048c1216d906111ada561"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end