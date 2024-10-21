class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.251.tgz"
  sha256 "cc669e31fe3ffd428fd97bc15c099c6740a4681347bcdb1e666a25ac65ff8033"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920a342429365beec8b349b4a9307cb158a73e238cf0fbb4f9b67d40bdbc7bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920a342429365beec8b349b4a9307cb158a73e238cf0fbb4f9b67d40bdbc7bff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920a342429365beec8b349b4a9307cb158a73e238cf0fbb4f9b67d40bdbc7bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b7a837be18f1df2223a3fbd8854c43ce994e3913d5830167193a98b52d4224c"
    sha256 cellar: :any_skip_relocation, ventura:       "0b7a837be18f1df2223a3fbd8854c43ce994e3913d5830167193a98b52d4224c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920a342429365beec8b349b4a9307cb158a73e238cf0fbb4f9b67d40bdbc7bff"
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