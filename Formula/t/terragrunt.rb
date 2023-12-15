class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.4.tar.gz"
  sha256 "f31e9f3d225785ed8d8091c2aed7b65b69b00fb4f71853f85d11d278b3c487e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1f699296af1dc993ab2a3555720b75cdca2891376d983a236575c563b7edd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b816d9ebbf6c3ba480b92bcca24a802faa51230a2cbf01a3174fdaa59f7f487f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96fb929b9c626499a950f90874ef8ea3792bf28a9c8924c6a6ef81b4bdfeb314"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3e2b81e4786139865f775711ae3a6b4bea9189a21f9907b873c820ecfa27808"
    sha256 cellar: :any_skip_relocation, ventura:        "cb7e35bfa1c3e0df98bd4fcd3bbb918b61757a4ba2d338dc458ec7d21381c7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "36ddabf272801a3bd6fd5375c0c5c79e2dbdffc6d2526e00eb0ba3ea61400e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e13f51d99911633b46dedfeac9cc8359c3a039f885d7d29ac6b9977adc1d16"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end