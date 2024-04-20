class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.7.0.tar.gz"
  sha256 "0cd389e10800df63ee5678038f4954684695561fc644fde4b514407afef9a426"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f666fb05e5e6cf5c8411ab47d7fc76d3213d08cad775d86febaa243f97dc2f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e21973343e043766ab3823a7891483631f56d73443638b63c15fae39bfd6ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f71cf724806d1e3dc401d06da27fd9e9563070f31f2bde187bf1f5e6261a77a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee375bc0d7af2814d252e599f2ed174b4f70bbd803b1d08593008fae4f4a0e46"
    sha256 cellar: :any_skip_relocation, ventura:        "23397c0a2cfabc0616210bedea27b16e614b61a24fb6354ea30cf19eeb77bc9f"
    sha256 cellar: :any_skip_relocation, monterey:       "f8f466df87a51c690b53e6a822086f7c042795ff40e19f7fb5a1c357c1dc47a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1995d96936c34058700ed8bb6e3f2e7f5a6185177a2219cbfa66ced12f2c23b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end