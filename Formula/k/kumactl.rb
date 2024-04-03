class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.6.4.tar.gz"
  sha256 "088c97e0c5adb13c3d8f06b69277c0e9abedc92f21b972616348c6c06dfada7e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "114c784aac8c316b6d8dbb4755c3c6777dbfc71578fa90fae9ae5fa7f21b0dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba685898c47b8a445ea259d7301bb98fa28269ec1a09fdc77b481964b1cee28a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8480eb5d1b7d7add1de8d112aefe8ae95a6e4c058442ad0fa2ffd26f37a9bc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "abefff99442e3fee911fd831fb6a01cf4d1cb0407f4f02c6ff94ec6d930fc62a"
    sha256 cellar: :any_skip_relocation, ventura:        "409e931a69d55a481a870ac8fa7ab7db99936c8a3012d13e04085e9c696344f0"
    sha256 cellar: :any_skip_relocation, monterey:       "fe60904f5bc8106faa53720ad8dfe2c26f969907b75be801b08634fa71c7abb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49890ce787f318aa50c4276e512eb15cd8e19a1e1ee1e5e14aaaf85c3bf772aa"
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