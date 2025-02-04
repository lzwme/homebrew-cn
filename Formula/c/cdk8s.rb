class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.313.tgz"
  sha256 "441ab1525dabe9651716bbbb24836a959216327be33dab1a6917ced0555085f9"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8198326248db689d1979112f5e4f6184aaf1cb7443b43447a130dc63843b208a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8198326248db689d1979112f5e4f6184aaf1cb7443b43447a130dc63843b208a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8198326248db689d1979112f5e4f6184aaf1cb7443b43447a130dc63843b208a"
    sha256 cellar: :any_skip_relocation, sonoma:        "60414fb32c3227ee8e49c3f418c9f4276038446e70ac31f5478ca158f5db1e7f"
    sha256 cellar: :any_skip_relocation, ventura:       "60414fb32c3227ee8e49c3f418c9f4276038446e70ac31f5478ca158f5db1e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8198326248db689d1979112f5e4f6184aaf1cb7443b43447a130dc63843b208a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end