class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.6.3.tar.gz"
  sha256 "83fdaf80e46aa47ed6a95d6d13778fc6d921aabaa6ac6df64de506c3dafab210"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f36fe779c8380fb9b5fd05b6fb51c21eeae6c5385537b0a7388d5cd2ae6352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84970f0709255a96d09507412bb1b648ef94c710440ce9dde82732490754b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6138524adce7acfd676c27afa8cfc363078ce95236dde3cb1860cd2f8464ec81"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe9e6c7f0e8898d43fb3d0825d4a51b1127ee8aa954597fdd4c76d222285dcd"
    sha256 cellar: :any_skip_relocation, ventura:       "3a2521f29ed1b2c2c1ac79a859eaa2d3d5b2ef66e2aa5b56e4e74dcfa1ec3f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd63449e026ab9eb85e82c3539440fdeae4835757a0d2d0749e0c7b61dd30409"
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