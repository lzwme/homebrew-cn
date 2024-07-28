class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https:github.comtsenartvegeta"
  url "https:github.comtsenartvegetaarchiverefstagsv12.11.3.tar.gz"
  sha256 "7106d7e81a03d32a58391b18921d69d54e710b9052b59fa4943c1b552500196f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb1464c40cbd016773c726df941089179c2671568fecc17753ebdddd441be250"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca91aa5b68e88e730912d1267c5c95b87f16f361d91bbc33d22fb170af33d252"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b625ee805e8bc2109318d660a4080387a066b29378c76cea3261816d2ea91c04"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cbe3cf4373c904f54bc078dcdf6d507e55e7019de5517548a4948506a17d1cd"
    sha256 cellar: :any_skip_relocation, ventura:        "3e4447b8bb61c4edfb1b58e3d4f40455cc34fdf40388bea1e9c50630dafdca89"
    sha256 cellar: :any_skip_relocation, monterey:       "503f966033bfc760c400c3d96e4701000408cad9eb8fb39a45eedda505cb884a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4587eaa1d1d6a8f2f840057710ac71824784fc76c93cc632c0b12ba7598b2a9c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    input = "GET https:example.com"
    output = pipe_output("#{bin}vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}vegeta report", output, 0)
    assert_match "Requests      [total, rate, throughput]", report
  end
end