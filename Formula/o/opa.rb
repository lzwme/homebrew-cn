class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.68.0.tar.gz"
  sha256 "5c7f985b70d69f208af12d14c2d73ef802ec8fdb6025795f94f1edd9ced82033"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b3ac9bc7d9b005382ef5041900080e4238448b712546cda0d2f7b189c20cf5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f51b78f9064809462d314ebe94b884ab6fc4fb7055bde0411ccbec61d3857086"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c72849b93d763dc4bc5ddf9f1b82b6e011b7ca000f43a9f5b50831a66f5f410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ca95050dc9667ce013f80ecdd9ffeafb3ee3965645b5aaeceb959fdb0bfd35a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7ed17b217b88f9bb6c5d8caf9e529b08228008792dc570e52095f5e7b26e35c"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ae19bd8a00ac33ca29821f8c6e576e89d8ca4a4cfad0e8fbedbeb97426106b"
    sha256 cellar: :any_skip_relocation, monterey:       "fc579cbf20037cbc383ca689ba1e9dbe1801d29fc7851711b860b4a8aa1673fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b2afc11087f944531ac894d7dd9b6b3c8d4a3d724909879adf904b33460a7e"
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