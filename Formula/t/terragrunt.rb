class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.6.tar.gz"
  sha256 "a7c3d2d05199fb1cfdaea178250aab03f26f32fbb4e8b46ae0f027a08b2e44b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ba65df0e705772f7087b61461d229614b39942c19a7fec9cda1425e71a3886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ba65df0e705772f7087b61461d229614b39942c19a7fec9cda1425e71a3886"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76ba65df0e705772f7087b61461d229614b39942c19a7fec9cda1425e71a3886"
    sha256 cellar: :any_skip_relocation, sonoma:        "e320b764d1f37d01f0663ee74ff1392b659b351a00e098e836f8c27f3dc63416"
    sha256 cellar: :any_skip_relocation, ventura:       "e320b764d1f37d01f0663ee74ff1392b659b351a00e098e836f8c27f3dc63416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95fa199151eeb8d1b2fa3c413453651ece06417210fdcaa2d097db65b243c8df"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end