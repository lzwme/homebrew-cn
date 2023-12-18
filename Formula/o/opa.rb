class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.59.0.tar.gz"
  sha256 "d178d4126d3209566dba1a230dc2e77d377710d65e4f74830749148e2bf2cedc"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e1599ac14db5af02e5f53cf4609583184d6e0e41d0f9084d73983c7acf23f42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "530c826c51cdab834a272e9b7c41f90aeabf86b7656ce3e0ee6508e343693562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b643c8f03c7c220887de91974692a9a4bbc084c2417883fd7e6d28c1d1925064"
    sha256 cellar: :any_skip_relocation, sonoma:         "23adda58bae163e77c3553305a31e43fc295adb3b376836c9bab08725a18cc5c"
    sha256 cellar: :any_skip_relocation, ventura:        "1c23f43eaf0a8d15fc58a0a8d92f3835944d87236a384bca5494d418fe0a62ff"
    sha256 cellar: :any_skip_relocation, monterey:       "ed02cac319bcf37eb57e2d1c9fe6678fe89cf0a53a4d0e36cde70c04da19a52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76e2eee92948fdece5bcdf17c44bccb31336cc72ef4037f230cf62803a150b8"
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