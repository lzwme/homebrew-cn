class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "dd4ebcd6b7eebeb45513618f684d0099d569d2d2662fa44a74058129728b7192"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3cf5341878b8390c0e7359e0ee27e297e406821003d54231f4928e4c28e6e06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e213d0cb83725cff895309cd44d385b17635102556ed1eb4f472d3e51d85c76f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fb1c163a324ce0754a96f82025b49907c736ac967428c73dbf27106c29ff630"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab3d642aa19b4776508edea9bc3981d304107da052cd088bb60d03793db003b"
    sha256 cellar: :any_skip_relocation, monterey:       "786076a003bb96634cdafe7b188e2abdc6cf6589be9e9c07acbe71819073c57e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a17dd4c2eff663215a446fa5a1091915b3737ad540f412e288ed7bcd09f35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc852af8ebd952a1e4e858e662b10a0f1f39b07a3e0437ffb75013f3ce5a6684"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end