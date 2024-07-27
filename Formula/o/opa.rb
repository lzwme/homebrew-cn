class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.67.0.tar.gz"
  sha256 "d3a422e7ca5ae5b2a0619a52caaf3a6f0ca6a150a60b75dfc3bf254bb8f78aa3"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bee7453d6839f3765a76c95d11db4fc0f5ea053efd653932c12132eafbeaf05f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a62bf51e74d55b182b541fdf15024ae55faa57bc753c3432a763a701eda50af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77adc2a8f6ce801848393f118c2b6c80fa91df38a3503d8026e6206680878cd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0f3e7d37274bf2187685a3836054a0078abad6a1d18973021329441319d1c79"
    sha256 cellar: :any_skip_relocation, ventura:        "14756257ec3b6081332da2248df6ec753d13afbfe37e74a214c771cd640b983c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5470ceb6bf5be28dbaa6e575ac6b295f60fef169b09316b98fc80d876737264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24cd136f9f37c3a607acbce887102dc647e93e7e5e1ecb23076ace4408c0718"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentopaversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system ".buildgen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin"opa", "completion")
  end

  test do
    output = shell_output("#{bin}opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}opa version 2>&1")
  end
end