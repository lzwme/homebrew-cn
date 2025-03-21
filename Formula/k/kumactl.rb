class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.10.0.tar.gz"
  sha256 "f2f1616d53a2a06d43ce09a43fbd8104f39186647b3e6110032d4aff710d341f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e57541dc837e3b9351e96402f98725fd5086c6779f580994af7b332df13d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3cbcf18ed8e92979e8797e4246bfa21414e72e46ce3e729beb375dd8b3517f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5a1246e433f0cce5f9ff153865d6345322c87518eb8e1d93cd92cea78620ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41b3fc81af69ce828cb5c72b1ea943b1c99526d062be37e5baaeb688101f9cd"
    sha256 cellar: :any_skip_relocation, ventura:       "e181b2807f79404ce3885929a9c39c7e075c872c66c191ac4a1a2890f66e3302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ef15ec11feaed2e25a96418613e379409f15be1727f97f2e88589ea93f98c4"
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
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end