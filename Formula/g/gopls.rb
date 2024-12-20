class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https:github.comgolangtoolstreemastergopls"
  url "https:github.comgolangtoolsarchiverefstagsgoplsv0.17.0.tar.gz"
  sha256 "0d362528c42d4110933515cbabd7c6383048eb279a0b74a6322883acbcc3a381"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{^(?:gopls)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d156d28282c10967957c40f1ea07f048ce3f3b1d49b7e2de37d3b70cb0b892e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d156d28282c10967957c40f1ea07f048ce3f3b1d49b7e2de37d3b70cb0b892e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d156d28282c10967957c40f1ea07f048ce3f3b1d49b7e2de37d3b70cb0b892e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cfc1a6fdbeec255cbaccacdecc385b92d6cb8e57cc368e38ff05f72ec09fc78"
    sha256 cellar: :any_skip_relocation, ventura:       "5cfc1a6fdbeec255cbaccacdecc385b92d6cb8e57cc368e38ff05f72ec09fc78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bed3dd34535a938cda120f194071ea2082b4509a202ff0d26db1677be4e65f"
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