class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.62.0.tar.gz"
  sha256 "c3dcdacc4616d66a8c060add478f6cc287e5f39d9fcdc50ac250c6d993837a32"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b314a8a93502848df6eabd5f1febd71365a67befe14c26292d32ecf13f082c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af36d74df15cd2efcf05c148ae117b23c9e901fb30be0aa8ce9ac04c1bdfba5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0408bd631b5d66f4f779854ce4937c91f8a5354721110224e2ff2a2b7252ddf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb02b4272fcc6063ea1e6b642187f36705e3411086501bdfbd9be67ff3723588"
    sha256 cellar: :any_skip_relocation, ventura:        "34933c0bacfb61844751ade44258015f89d92d2e8821e83ff0c3e20280610d90"
    sha256 cellar: :any_skip_relocation, monterey:       "1685dda509e6bb78b7374f4ce09228c6c5c138aeb2463d460b04397f0498d16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37849ca1a9c075bac85400ea7b230f9d1393dd4626e67b30553740056606adac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentopaversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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