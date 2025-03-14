class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.7.0.tar.gz"
  sha256 "171e1c72b117b702eea8559f8411bbbb63afeb3a1b468616a0faac13f2775160"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8882f2915833d44944652bec35a21f30ab15934206c273328ae3c4753babc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232c08826eef542f9d39c2ae156b9a585f4dd0171f2cb2c698ad607516b7db31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2889b5f037c851105fb1a26572e730a31a36467d10a0f126f73d9b358120644a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0aab55fa475fab78d281ecbb16f95b00350d146ebf9e22a0866e9a97012aa30"
    sha256 cellar: :any_skip_relocation, ventura:       "ecdb7dd87fc3dc5728227656046e3597a7d1e179ff8c8f40fe8692f76773941c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25426a288d00acdc314e986fc106018d4382b3b3e459599d8e65642a2096591b"
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