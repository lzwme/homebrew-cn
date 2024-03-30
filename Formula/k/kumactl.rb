class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.6.3.tar.gz"
  sha256 "6a0483b5d057e69d3e57d0e60b6fddc44daebaa2d602475a368a7a9956672432"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "154f4f1dc2a1ac6db76a0bef54d023ef901bd7be2c26c6976de84fa2d29a6110"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c7a5f0310aada77043547acaa1e91480efd9e982823fd2b0173f0b4fb06ca4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5523c5169cc4d43d9f7f50ef61121830521abae4bcbbf29a68f9b4979b9af65a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a40bf239ef594a20a3382d67785dec02665c35f4ff9ce44a54691ebb59fa88ba"
    sha256 cellar: :any_skip_relocation, ventura:        "d0c853a55719d1b48433137007cab85da395a4190c7d79588c469ac9e9079fae"
    sha256 cellar: :any_skip_relocation, monterey:       "c5564be2c65f88a2a9b04c15b82869f841b3b4ca035245f3d14af27e734ca7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb25b74cb5d768aab059cf680c8cb227ed48ba9b70b945272cf496d289575f4"
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