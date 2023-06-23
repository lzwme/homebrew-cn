class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/gopls/v0.12.3.tar.gz"
  sha256 "77fa296b58ea38d9727b3f564d28bf816eb05ffaa587a2830ef405e479dab060"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313c94db7205dda4f28f5789dbc0739f013305310b9035b6744fbdc904cc64b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a112becbb113a68cfda758e1dbe2f96c20a121760dbcc8fe8304394a5e8370b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b693c47d074acf551ae90eeea216a135d8401ce73ee46048b31ade16ba340fa8"
    sha256 cellar: :any_skip_relocation, ventura:        "3b1b2cc5e821aa57d893e51baa36407ee842555ff18a840bbf9015e0c54271d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9285b77e5fa5d78fa66466a65673594710777d13b89f92b14ba2e491c2ae07b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a22764b64dbf3d466b0f59543ce09bd1c043243ca6c54981bd897ab7f48ee6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c980a5c304252493fa3fc891b764457c44951303c1f6dae97b926fc800472f"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end