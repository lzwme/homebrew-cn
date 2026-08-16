class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "bffb02637dea11ab1efbb7c2af7ec4ecdd336f92d80d3ed3aa888f039f0becdc"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "815ddfa279984120caa2495b68cc842c5fc308f07a06b483ee749ef9fcc36347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "815ddfa279984120caa2495b68cc842c5fc308f07a06b483ee749ef9fcc36347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815ddfa279984120caa2495b68cc842c5fc308f07a06b483ee749ef9fcc36347"
    sha256 cellar: :any_skip_relocation, sonoma:        "36fa7fc490745aa974631446f79779e27b354cd76e7ec6af14d355805e63d20a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba413db2eb089a742187843795d7c7fafef3ef5397c13cab1cd088ac3158f4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df73471c48e7d6b4d8df6620d41f8be4706dd21ca91c5af32a58f3beee825d3"
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