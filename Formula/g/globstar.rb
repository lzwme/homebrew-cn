class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https:globstar.dev"
  url "https:github.comDeepSourceCorpglobstararchiverefstagsv0.4.1.tar.gz"
  sha256 "976aa520de6b3727f84f0a6e74efdd9baddc78d498f1953160c4fb1f7bfee2f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4242c4ed808e1c0d2b5fceb5daef93e979036896d9150a19b5081a1349fa5fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce1d87d65cd514c242699874788763b910de6f6beace0595f89bebc409fe18d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "586d5995c98e5b985ec03e6ef8bd483ac1d4efd4b2096ea415ac02a57f6a66f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d345e4676ef8d863911d46c473f8b5a73ed0930872648f17d090adc598bab8"
    sha256 cellar: :any_skip_relocation, ventura:       "5f4f7568b465ad37258c9f9134b1479f2137b31b718263bb63f893d638877a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe23b6b6cf5b418475d7e48b0e8a4fe44e5f9258a9b8b094d4ce1c6c18eb6313"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.devpkgcli.version=#{version}"), ".cmdglobstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}globstar --version")

    output = shell_output("#{bin}globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end