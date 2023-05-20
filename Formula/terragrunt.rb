class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.15.tar.gz"
  sha256 "9738a5d00afe860ec2aa8f1f5bd6566d302cd301fd50358a2b970eb9de3072de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f878cc4f01aba1ae1687c5a3c664d7b4b2fe1143f9e2777282b9a24d5e8697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f878cc4f01aba1ae1687c5a3c664d7b4b2fe1143f9e2777282b9a24d5e8697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4f878cc4f01aba1ae1687c5a3c664d7b4b2fe1143f9e2777282b9a24d5e8697"
    sha256 cellar: :any_skip_relocation, ventura:        "43434cc6bf2db5965e93a639e4a2f201545fbaaa5843a4109cb41cc8688ee724"
    sha256 cellar: :any_skip_relocation, monterey:       "43434cc6bf2db5965e93a639e4a2f201545fbaaa5843a4109cb41cc8688ee724"
    sha256 cellar: :any_skip_relocation, big_sur:        "43434cc6bf2db5965e93a639e4a2f201545fbaaa5843a4109cb41cc8688ee724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7feb9c9fa7cf03a7aebc0cc017d8c895628afcda6c246d5922f136bd8d311d16"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end