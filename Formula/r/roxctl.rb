class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.6.2.tar.gz"
  sha256 "36cbfab7cedf9d0fd294fde6fdf7575067486c86f8f064f54b5527c445de3e45"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c30080f70ab321a06e01c6dd53e7676af74a1b8af3fec7f22a2c52c2c4b51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2771e844a1c87fce6cecc60aaf2332a62587c13638d6e07bb4e0bc47851115d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6cfee53c7e6d3d53a42979d041a69bcd3177118b774afbd323b206c0f9e5e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ef84d1aad9c281b446ad86e26e716e019a575f28e008fb87fa64050b22a4de"
    sha256 cellar: :any_skip_relocation, ventura:       "b0e916a9672d04cdcf0801b7eef7a91a9d2e33076ff9049c32ac4b6ebcbdb5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38817b962f786864180514e6d0ae61674853b7a014a7bc49da65025948aed8e8"
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