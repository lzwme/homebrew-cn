class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.6.tgz"
  sha256 "24801c0615c706e0bdeeac361f69cfaafe38061623c453e75c7e0544e33abf4f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb870da96125001ee58c8e8805636f32c732d2ce408310505aca551fd4a3c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb870da96125001ee58c8e8805636f32c732d2ce408310505aca551fd4a3c53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fb870da96125001ee58c8e8805636f32c732d2ce408310505aca551fd4a3c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9d1f2c181163d29c63590b32efafb4db1b97ed52a4a7eebc34af1b87f427452"
    sha256 cellar: :any_skip_relocation, ventura:       "a9d1f2c181163d29c63590b32efafb4db1b97ed52a4a7eebc34af1b87f427452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb870da96125001ee58c8e8805636f32c732d2ce408310505aca551fd4a3c53"
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