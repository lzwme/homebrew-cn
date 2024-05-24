class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.4.tar.gz"
  sha256 "9c348e9f9f9a83967bc4db35762b102684b2f2e1d75a29bc6a1eb4ed943e9e60"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7d80c6d03fd071239155a638d066bd598374acaf3345075e6bb8800e5044cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d80c6d03fd071239155a638d066bd598374acaf3345075e6bb8800e5044cde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d80c6d03fd071239155a638d066bd598374acaf3345075e6bb8800e5044cde"
    sha256 cellar: :any_skip_relocation, sonoma:         "22c91ddb29d806dfec2a716b85d1721865d92db806bd8cb8917ec20de081b6ce"
    sha256 cellar: :any_skip_relocation, ventura:        "22c91ddb29d806dfec2a716b85d1721865d92db806bd8cb8917ec20de081b6ce"
    sha256 cellar: :any_skip_relocation, monterey:       "22c91ddb29d806dfec2a716b85d1721865d92db806bd8cb8917ec20de081b6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fdea8b7c44ebdd2d09468d7138a1c936e9887944b9f11b409e8c26dc1deeaa8"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end