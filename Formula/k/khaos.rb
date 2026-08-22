class Khaos < Formula
  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://ghfast.top/https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3d20d75c1977eb9c490f10cbe09cfcbfdfc673479f499877fd7b872555c0c0c1"
  license "Apache-2.0"
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c797d35545381bb2ddeab304f62a3929519e995a174b4df136c6c9000334cb87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c02c8c47e1086a84d2ef25b4f65fac073954f856e97c41534851f1758e6f166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc1ac53840ad1cd73b03f5ab6dd66fd61062988dafe17eeca8013c9e0e1e710"
    sha256 cellar: :any_skip_relocation, sonoma:        "a979e22cee1db203c14ce71e73b47530bc499b0b96475969fd0f3885a53372e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f647f32f73ddce41ee4766ff3e2bb136c280c39968baba264dd38588ac6aa41"
    sha256 cellar: :any,                 x86_64_linux:  "425446af404e614f9250ac55de5e9dafb2b03c65e14c1291fcad27529d329382"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/khaos"
    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
  end
end