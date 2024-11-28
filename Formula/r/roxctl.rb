class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.6.0.tar.gz"
  sha256 "e2740569a62a364e3eb446752a1ec6551e3a48917ef2454212c0c99b7023868a"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e00e37da0dc2e8293fc9fe39f4f56ad88e962bf8f625bbb2963ce63de9fd5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c62db989f00b123c67d5d99ad15c1fa96d06608ee9d6e39ea04e5a231ae621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37e882911c3267224ab08edfc77f57c51a81252c4f046b0c103f0e0af07ec7b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a645b88ffd52cde7e33cb6ddffce86b04a2276dd2a4c86e12684f665707770"
    sha256 cellar: :any_skip_relocation, ventura:       "47a59b8557c22cde47be0e90b367d9ae2caaed65a2afcf596c3e456ce0fd327d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af48451396abcdae8acfd087a481b384910f46aec11d08f94d27331ca2a4cf75"
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