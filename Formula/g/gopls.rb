class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https:github.comgolangtoolstreemastergopls"
  url "https:github.comgolangtoolsarchiverefstagsgoplsv0.16.0.tar.gz"
  sha256 "0775f9769a4dfc54dfaa41182d3725f44a8fd6eaed2568390dde7f5803f931be"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f30cb1f24555ec923809d8085d869bc07782d8a40adf162ef716303aae88c23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168bc20bc72c36b99d369ebf37a834b963b37687fb023235310f0e099db47a8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae2360b14d6c9b0c0e0e9e5da642a5ff9eefe8af6e5c6bb9fe09b008570bb92"
    sha256 cellar: :any_skip_relocation, sonoma:         "79763cac78082d6995e55717439bdd3846200a47ddd5090709ed4e7851de9fff"
    sha256 cellar: :any_skip_relocation, ventura:        "aea5146f663b706f81eea614069f28b9f8913f457846a0c5bf3b96344bcf18da"
    sha256 cellar: :any_skip_relocation, monterey:       "4efbcb14601b19d057f9dde3fafacb5e9e847330e7ba122984101ce443ae89f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f015e8fdbb641ca6f710f63bdc4412b44cdf0b61c16d7c30aaaa4703e7ff5c"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end