class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.0.0.tar.gz"
  sha256 "1b7338b645b04b238dab794033b5bb1277b4708a271a68d19ad75dc172d40738"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6189035bbad51739a18a88dac695e8ae359d55a5688e33ad9f6ec8b94bad5b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6189035bbad51739a18a88dac695e8ae359d55a5688e33ad9f6ec8b94bad5b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6189035bbad51739a18a88dac695e8ae359d55a5688e33ad9f6ec8b94bad5b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f7858cd8a4a210542d437b7c690bdead024dc5bb69367167f3d780547dab18d"
    sha256 cellar: :any_skip_relocation, ventura:        "2f7858cd8a4a210542d437b7c690bdead024dc5bb69367167f3d780547dab18d"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7858cd8a4a210542d437b7c690bdead024dc5bb69367167f3d780547dab18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ddcf2f7833bbe5fafcfb0479ce2eb661da2fd72b787d73af1e686eabbfba7fe"
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