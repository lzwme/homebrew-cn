class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv1.4.0.tar.gz"
  sha256 "fe56473cce125a1c00ff8dafafd3d83ee29576c730b116a1c577f942d183abc9"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6623f6b05c3f341e90ff571c10788635f566465acd8307146f6255b290fec226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb6e38cd91da61daf96153079ba794224ae80d17a45b74020f08ea3b7aa76df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e548da09f5bf1c17cbe495eb28bc50a6c18f95c39c1a2733cd3531111d096b"
    sha256 cellar: :any_skip_relocation, sonoma:        "27516fb1cba47b9828f00b832f068606169ca461e74eed3094a01951af0983ae"
    sha256 cellar: :any_skip_relocation, ventura:       "08199c03d72d1a27e83b92bb4401b3ad1b6deedd334822cd07d4ac94d585007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52442da6f33ae5cfa466bba2601da84807dcf658791ecb9c6163b14ac37037a8"
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