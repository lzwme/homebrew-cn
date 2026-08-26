class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.326.0.tar.gz"
  sha256 "af2379f2e7e793b618a9380b806a8aeec7b7e8926051a4a2e647dd46fc0ca0b2"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1be1f702f46cb2e0bae96f4a6481e72f8c92417bf7ffd98653b920499d62f30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336c99f797f2a1de247e0a4ccae98485342cc64b6d067204e4866ad74804e237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07913a7b03e71b56b9f13ca03e0cf2c9f24efd32e242214f4a13b1e2e9fe0520"
    sha256 cellar: :any_skip_relocation, sonoma:        "576cf2845d60f2274950f82360095485b7c5bf8d87fa04ce48ec3f76fa5e76bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e31178a15bbe95fd9abf2a9d55a72877e7c431659019b0747ed384ba0bdb808"
    sha256 cellar: :any,                 x86_64_linux:  "905fd80a5cc20149c7a34bca4f79ca70c3c1b468046012f1b735620954eb7524"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end