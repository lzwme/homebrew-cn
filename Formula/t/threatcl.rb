class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "1a33d46421d03315000f05dea787717f7a2a54aa0d236b463ffe3a5db46fc785"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde7d8b0fc0dae2dafc99065fdffc58c07e4facdfb9bc43b154db1d1ea8d4cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde7d8b0fc0dae2dafc99065fdffc58c07e4facdfb9bc43b154db1d1ea8d4cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde7d8b0fc0dae2dafc99065fdffc58c07e4facdfb9bc43b154db1d1ea8d4cb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58949ae0c2db8500623577bffc7466683f642ad2a7206452337671898b5adb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fac8b2ea32d98ff8d72d7e44f149292020b87a1726a77250b5caa0b1f34e8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2594196b2e9815f0cff9dad823f44520c121004ac183d9ad6c681417bc025a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end