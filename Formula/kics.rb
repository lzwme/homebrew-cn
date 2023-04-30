class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "d4d0f3349d9099f396fffbf22459cc7bc4bcd153e11fa9ce0ca0bf945edecd97"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1729d27f4c84f3c3be21fb619e6917812130eebf591410d4d9214f61d8519f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d88ee11886f9a1d0205e87304b7e538d7e5a37f65c47ffb56eff0037c0a8d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a927b75dc38b6a1ab146029ba2f41bad224ffd9b7e843ce2fa59f0abffff129c"
    sha256 cellar: :any_skip_relocation, ventura:        "c58e2014ce2d2f2e1ac9ea81d805bf32eca75bdfb758cc8ac7860298e000cc8e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc717e9cfa91c25f8b0bedd5e33b70ec7730e0b2d75482abbd292486b5373598"
    sha256 cellar: :any_skip_relocation, big_sur:        "9368730a22f442c143737e5a8ac5fbce761effef505af42500d7c20e69cd1d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74ae115b6728134a678c82befa67f0e6d0e4d87d8e020424e5a98917207fa05"
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