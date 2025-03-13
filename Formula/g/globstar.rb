class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https:globstar.dev"
  url "https:github.comDeepSourceCorpglobstararchiverefstagsv0.5.0.tar.gz"
  sha256 "9d56b84722fd95999f69646b87afce8cd166f74ad29da31bfd46a5a7084b77ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86602cf26e12eee612048bd54f971415b520bb0c6688d1843b0aa8375fafa41c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d557d29358d9cad38c5c64196f32145478dc62f572e50172006d62097b1118"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca1fe29b075c256b708942a0362b0bd057372f654a605cb0ec75ec2f3a89cbed"
    sha256 cellar: :any_skip_relocation, sonoma:        "273386e83fdf02388d56e4b68347b579e151980ea5876c5235251281327209c9"
    sha256 cellar: :any_skip_relocation, ventura:       "4834ae2163f809777e60b8e454b1a1f089dd441b911751f480d210784207475d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9936485bf91a145a15ad20b9dae1010d3a95dcf64aa8f5aa942efcad86873925"
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