class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "99e09c5a95618af4331ca5e2a45e881f36d196e134a716f7b01cdb0e8ed514d8"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19bc44fca162f2317d5a3e1501931f4ee0f98986b9ff136c516fb0276fa5f655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19bc44fca162f2317d5a3e1501931f4ee0f98986b9ff136c516fb0276fa5f655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19bc44fca162f2317d5a3e1501931f4ee0f98986b9ff136c516fb0276fa5f655"
    sha256 cellar: :any_skip_relocation, sonoma:        "77a1e3c47c13ea6337ee08b6e4ba1f5bcee22c1b1172d72580c59af707b39ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474bd454414a2643394cfcf14a06936f6f23da83b0b611b6632f44ae0e77cccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5a0dd3660382e9193e059a65710389041fdabffead8f8418afd388ac4bdd1a"
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