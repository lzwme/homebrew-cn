class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.25.0.tar.gz"
  sha256 "008e46fb186c069b6f229308129f7002b0aebc4cda51ef0cc73df912a0f3d796"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ebfba39d87f4d6a0694db84e9877df50ab26a64d5eca54490e34add27bce178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d265e40c33c1c91a2d0a102892b7926dfc8ff6e76b2b40dc37d2906a03c9a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f57f7cf2e02ea54972e1bc0f3f7bfac84f336e772ca951f4ad9b8b02b44832b"
    sha256 cellar: :any_skip_relocation, sonoma:        "60356e4d70fdccaa634c9d3e5ff97f59ebf3ca038e110cb55837e860be5a1537"
    sha256 cellar: :any_skip_relocation, ventura:       "cbf7bfd5f93cd4e1917f87d49c2210c5b838d8a727dddc608a5a3c82f61b8c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d1fbd0fb6ec25a2b621f8f8203fb372f279b7a9c279a7ba09eee4cef3a3c04"
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