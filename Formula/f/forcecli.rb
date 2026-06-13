class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "fce04a6497972a611794dddb7c30f858e9f19c4bf37cb6b014b60225b2e68ff6"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17cd2d80b9a4d9a2a1ca5460b6676c731a801f52c55576716bdf4522648dc9c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17cd2d80b9a4d9a2a1ca5460b6676c731a801f52c55576716bdf4522648dc9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17cd2d80b9a4d9a2a1ca5460b6676c731a801f52c55576716bdf4522648dc9c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab120f980a8d611a08d32d9d9a61cd560da75c5e0aba296f35351ae21cc9068"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e244955e7883b9f2603750cfa512dfc5e1dfc50b1e84a358edefb2aad9bc3f3d"
    sha256 cellar: :any,                 x86_64_linux:  "aee1633d9ef095b19fdbb6c4cc1527a236e6772ba1f66dc7d51ebb566e19754b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end