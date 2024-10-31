class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.10.tar.gz"
  sha256 "ea8eb905229c43f0ea43394003d9832d225deda2e54bbf2d71d3f47b7e2d471d"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea8ceed704f04d2ff1ba487a920b1e6811e6cfbcfd5290a103f3c72ec5addfa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea8ceed704f04d2ff1ba487a920b1e6811e6cfbcfd5290a103f3c72ec5addfa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea8ceed704f04d2ff1ba487a920b1e6811e6cfbcfd5290a103f3c72ec5addfa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "262a989dc911e8f63b2757d88789431461730b2d0ec043983cdb23e90661d8dd"
    sha256 cellar: :any_skip_relocation, ventura:       "262a989dc911e8f63b2757d88789431461730b2d0ec043983cdb23e90661d8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57a0037190b568603fbee2577400a680dc33f6ceefbff5468cc7d8d5ff516e7"
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