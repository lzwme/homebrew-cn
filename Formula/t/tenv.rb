class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://ghfast.top/https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.18.tar.gz"
  sha256 "3f43f6f2b7ceb6efb08ffc564ca07420a5d5a9ba33c88eede7f35c78c824c681"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c868a7ff28f93eeed0c0427a2b8758abdf4e9223ea0242d4ab7d93a263102a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c868a7ff28f93eeed0c0427a2b8758abdf4e9223ea0242d4ab7d93a263102a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c868a7ff28f93eeed0c0427a2b8758abdf4e9223ea0242d4ab7d93a263102a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6515956b4db5cd575ff1091b3f568bb1d8d71cf9326cd31310fc476359ea5a0f"
    sha256 cellar: :any_skip_relocation, ventura:       "6515956b4db5cd575ff1091b3f568bb1d8d71cf9326cd31310fc476359ea5a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38487d3ce13290aa392ca33ded1c28c501eefb73170fd951c60c6fd9757f9335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4402a9d9cd621b41f28b5ef6c9540e36e1221a1d209f41c21a5a99781d97b693"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end