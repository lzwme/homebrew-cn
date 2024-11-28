class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.23.0.tar.gz"
  sha256 "080d243fbd333f2684989ccdd71bd3069ff36db6ac968acc656d4e1bbd924b34"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813c2f33a0605645d5de2be540ee98e6350506a281bd4c1f5fac705aed24ccff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2365da865502e24c6aa38bfbcc41cfedc5d5bfa0885d9533d01ec10643090f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59d6850218831d50a6653430860b01038fb429e30177b86b00cbfbc3a59de9fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f17aca01d2eb8a690297f17b43122c554acc02e734c197120684493916b85a"
    sha256 cellar: :any_skip_relocation, ventura:       "a0e09e662186275f4b8dce9faaa581f17362027db577a5b1cd2a96f2b2e14562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c42098285a62ef2b75c8f2f181e1e92c8d07115b394c0de53c5627c3c81b0129"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"aliae", "completion")
  end

  test do
    (testpath".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}aliae --version")
  end
end