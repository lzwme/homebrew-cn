class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.5.5.tar.gz"
  sha256 "7d6756f30358ce19408712bd9d8c9c4792faef43eceef308fd3eb8ac26e78dfc"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1126f6a04341f26c217495b43bffa5c780a14fc0526a022d25d24a5774c77888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe684f0273685438a7c8e96159f41941ff0c051df975a53e6d207e5b81f2d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30ca737a52cc1f6b3e2e36a2a0250eb5a8925bcbbc73b6243149d925451af79e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c072fd4b0f148134d9eb1568f8b861f9ebc2ff358bd3a6726679898fab2c39"
    sha256 cellar: :any_skip_relocation, ventura:       "df1f7380e3d2ddd4b16c981dd46224a6a4c93d8e062372f6402deb679adf4038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f35a8c85b7009061e10f6ba0473b275d92454925ade18eed5bde3a69d0cc54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".roxctl"

    generate_completions_from_executable(bin"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end