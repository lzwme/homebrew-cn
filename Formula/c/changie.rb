class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https:changie.dev"
  url "https:github.comminiscruffchangiearchiverefstagsv1.20.1.tar.gz"
  sha256 "0f6abc7b23cc7db940519537da133b2ac049829a9c409895a2ba1078cdcb11bd"
  license "MIT"
  head "https:github.comminiscruffchangie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98fd1e318885c040ed957def88f4521b5fe99c834d3fff4adc488b2b6f2b6a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98fd1e318885c040ed957def88f4521b5fe99c834d3fff4adc488b2b6f2b6a64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98fd1e318885c040ed957def88f4521b5fe99c834d3fff4adc488b2b6f2b6a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ebb539f611f376e79ff55943f5e83d0266a4ac4777199178161c1ebb69a52c9"
    sha256 cellar: :any_skip_relocation, ventura:        "4ebb539f611f376e79ff55943f5e83d0266a4ac4777199178161c1ebb69a52c9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ebb539f611f376e79ff55943f5e83d0266a4ac4777199178161c1ebb69a52c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3a0d43e80e102dd6e2c51a243fc2d84105844f9fbafe84646e75f003c92b36"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"changie", "completion")
  end

  test do
    system bin"changie", "init"
    assert_match "All notable changes to this project", (testpath"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}changie --version")
  end
end