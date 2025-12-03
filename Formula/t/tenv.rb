class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://ghfast.top/https://github.com/tofuutils/tenv/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "c8cb262f7e851ea70e083390928959ee85d1e5bdacabe255515b479044f21a77"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f88f4ab71b33bbe739a34e73291b1ba7c9651ac2636a700af5fe3974004f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f88f4ab71b33bbe739a34e73291b1ba7c9651ac2636a700af5fe3974004f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f88f4ab71b33bbe739a34e73291b1ba7c9651ac2636a700af5fe3974004f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "655c1bd74c52e47d8786eab4a3e22c0fe45d0c175f534d6c91c3f6b01635e9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1af3dae5d6db1014daa38e96bab6057e64bada4c412eb56224c9ce4840f8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1a87cdda83db11d58d15370971d429a5d930107ac2549488d7ea2acfb6a25c"
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