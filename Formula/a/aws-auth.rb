require "languagenode"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https:github.comiamarkadytaws-auth#readme"
  url "https:registry.npmjs.org@iamarkadytaws-auth-aws-auth-2.2.3.tgz"
  sha256 "4320fb53239e40b45d05b023f253cfedf70e283a957eb561c40c349850b3daa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, monterey:       "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    output = pipe_output("#{bin}aws-auth login 2>&1", "fake123")
    assert_match "Enter new passphrase", output

    assert_match version.to_s, shell_output("#{bin}aws-auth version")
  end
end