class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.3.0.tar.gz"
  sha256 "063d0eb1ffd30ea4c2e05043004391a0c6754e4e729f4a0944fc9255c0b96ff1"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbde7ff770412ac5b87f847b407a27588ea85659d45686e629f10acc4279c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cbde7ff770412ac5b87f847b407a27588ea85659d45686e629f10acc4279c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cbde7ff770412ac5b87f847b407a27588ea85659d45686e629f10acc4279c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "040f57a290fed771b99c2f79545f198dfbb4c252d6fb69db10cc13b350d8e52c"
    sha256 cellar: :any_skip_relocation, ventura:       "040f57a290fed771b99c2f79545f198dfbb4c252d6fb69db10cc13b350d8e52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f31a686ae601252f5cbae80a0f6056cbf7635f7ecaed4b056373dc08ca07b3"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
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