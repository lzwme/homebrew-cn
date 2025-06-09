class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Terramate  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.7.1.tar.gz"
  sha256 "beb41f5b45bf45055f7bea584c77cea1be51cf2ae212a464886c8bdd757c84c2"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d26bba33255d2059b5bf89c8cc3db0aa4234466415472b458a9f2eaec270b209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d26bba33255d2059b5bf89c8cc3db0aa4234466415472b458a9f2eaec270b209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d26bba33255d2059b5bf89c8cc3db0aa4234466415472b458a9f2eaec270b209"
    sha256 cellar: :any_skip_relocation, sonoma:        "13dc92110faeac021b24d8c506ed71d100b32745f8814d49322ab66dbb3b75db"
    sha256 cellar: :any_skip_relocation, ventura:       "13dc92110faeac021b24d8c506ed71d100b32745f8814d49322ab66dbb3b75db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47384cbbc68b414aaa8957837932dcde54ba1deb04f6fbf48a8c81cb162e3a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "017c1d0b555cb4833d65ff4344883a112e611bb8d9f3b766b442388e3a3b5d18"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end