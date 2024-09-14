class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https:github.comfalcosecurityfalcoctl"
  url "https:github.comfalcosecurityfalcoctlarchiverefstagsv0.9.1.tar.gz"
  sha256 "3e364a5315a5138e83999c34326f0d231b0fee2fa4c92801ad14d1b4eba64817"
  license "Apache-2.0"
  head "https:github.comfalcosecurityfalcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "986e6aac5d265b6e1ae2e1142b3b4a651ba1a6e42835e161aab550308291deba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8312a2859deb68e163068f9973c4d327217b8c4301a0ba883def4999cdc07df2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89e8a5d31f04cbfe41a45b6c2a361223abf7d33902ed53292f7172fcbbb99567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392677dac85a86945967eedea04cdad5609adfebdb495cfb6bb78f4cd6c6844e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1fafd0fba10c999a1aef966b201c7ab4582e9d1ba26b758fa916d936c3feed3"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c2c2196e327ad82a01f56752f0dd6c8c719d6fefba01b48c0543800f175471"
    sha256 cellar: :any_skip_relocation, monterey:       "6140e90d273f9b375a3504fc3715f835036fb76537645fa61312cc16980e0c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13eb10546aa3e523e97d73e86cd755db13dff64512b1f349e6cac9213a683711"
  end

  depends_on "go" => :build

  def install
    pkg = "github.comfalcosecurityfalcoctlcmdversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin"falcoctl", "completion")
  end

  test do
    system bin"falcoctl", "tls", "install"
    assert_predicate testpath"ca.crt", :exist?
    assert_predicate testpath"client.crt", :exist?

    assert_match version.to_s, shell_output(bin"falcoctl version")
  end
end