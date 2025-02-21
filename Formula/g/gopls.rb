class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https:github.comgolangtoolstreemastergopls"
  url "https:github.comgolangtoolsarchiverefstagsgoplsv0.18.0.tar.gz"
  sha256 "2fec8592c5f2e447cc1671c2addd4fe682e67a4ef0c10e7aa38376eb18378be9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44453a66c6f21449ca5f9d53db42980de8f206c788ed33887d1268732f3f98d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44453a66c6f21449ca5f9d53db42980de8f206c788ed33887d1268732f3f98d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44453a66c6f21449ca5f9d53db42980de8f206c788ed33887d1268732f3f98d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bc20f7e64c4c3a3d9a39c9a29f7e19e17ad14e064782555173faf11a11d8c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "1bc20f7e64c4c3a3d9a39c9a29f7e19e17ad14e064782555173faf11a11d8c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189abb3af5c9251468a37ac3a5d09ab46084df0051bf893181cafe15f866d549"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}gopls version")
  end
end