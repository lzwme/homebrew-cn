class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.8.0.tar.gz"
  sha256 "334d6ed2f739e9a8fbdfa478d8e2461e5d439a2b0c5f73ae97406e490ffc44f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcd72e4dcf9ba20d7fdbb59f1f845cfb492b62b1c57f8e111aa53f7558e1d719"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1de80b70f455fbdc1de7de54ccf576fa84ddd481615a1d1617d6b5532c83002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbc4c775e5315b722e570ed7ac5d20e279f152611968b033a32650cdd8fbf48a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4144d5ca02850eb513534e7a55413378826ba8f854eae7b1a9c6298781999dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d14737216cda856eb600a9887843679bb859fb59747927d954fc38bdc5ca62be"
    sha256 cellar: :any_skip_relocation, monterey:       "7873ce759b526ae1d7b7e7a8e2a796bc8fa78a3ce2264cc47c92d6ca478ac3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c1d76ebde9c4e75927e936db3c8632f4f971a8ad118b1d39be0e74053c281a"
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