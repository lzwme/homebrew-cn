class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.7.1.tar.gz"
  sha256 "0534f1d09489bc9944948d752779f5282a29406e6064b4c84e1fede4a22bfb49"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87dcddd565fef267061e711b3c1ca07731f72f52d3dc6c5771fecfbe12c39cb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e9c89791de826ee7a25874bd714ca80ec69ddeaad628624bffba2be4ec1b4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e031a69efeb1a78b945d249b8a10cbf81edbb097d3a998ce20570f440e8eb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e41500968b1d2e13f463c8d9ef4b1eb60d2e58a94b522ea1a71d809c1289e17"
    sha256 cellar: :any_skip_relocation, ventura:        "c48243fec91b0d6c5d667337a189328247125f5991d0621dd4366584caa3e709"
    sha256 cellar: :any_skip_relocation, monterey:       "eab0e2e0576123c28c4df86570c5793a015591d9a76804fc4d00c21a54a6120b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c5c40d24d0f6e0564543596899ee38cfadaf556d02562b87013cd2aaa9a70b"
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