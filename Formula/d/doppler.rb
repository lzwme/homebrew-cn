class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.73.0.tar.gz"
  sha256 "b3d69eb202d6664007c20a253b2890ca4712a0f405d566368719d2ce73ab6b84"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a62df112b4d3a7ac06a9dc08e9532475f14072619835d8016a1ba71040e8f20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a62df112b4d3a7ac06a9dc08e9532475f14072619835d8016a1ba71040e8f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a62df112b4d3a7ac06a9dc08e9532475f14072619835d8016a1ba71040e8f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a8afcaf86adff201b478f0d5fae6cf4c04e23c268d0808f67fa4aa434981c9"
    sha256 cellar: :any_skip_relocation, ventura:       "d0a8afcaf86adff201b478f0d5fae6cf4c04e23c268d0808f67fa4aa434981c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f95ef4a4577953c65326c223fd9c1274027bcde6f650de6f6b39a7c43949df6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comDopplerHQclipkgversion.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}doppler --version")

    output = shell_output("#{bin}doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end