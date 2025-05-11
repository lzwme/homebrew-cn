class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.6.2.tar.gz"
  sha256 "f3ebd348301163509d23c0cb6963c6f69bc9b942c54188c09605cd63f08475a0"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6ce7e9bad09e8bd50992c95b5f8d35ac5b28e8700fee5ac514fa3d779ee9b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6ce7e9bad09e8bd50992c95b5f8d35ac5b28e8700fee5ac514fa3d779ee9b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e6ce7e9bad09e8bd50992c95b5f8d35ac5b28e8700fee5ac514fa3d779ee9b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b1b9b245f934dffae30508c0379a5c2bd32af1178a490b1dedd3dcd1c3920a3"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1b9b245f934dffae30508c0379a5c2bd32af1178a490b1dedd3dcd1c3920a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bb14dcad2a77055f27f37602e94053a2778063390e7343321543059c08c936b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a700c655d9d5e746c6b3aa2a7f6919e1125a35a937ed091d77e0ce82f3d487"
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