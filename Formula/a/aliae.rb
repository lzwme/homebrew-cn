class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.24.1.tar.gz"
  sha256 "5e204a321f0310562f55e3063cdddd2003b5220d03e8519eb3bc3827498a1abd"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90691fdfdec2d50c8f7e55bba703d7a21ad03e2e1f5ded447a5e63b8eb11bba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182619dc717c3ff2631d0a97c1bd1f68cc8b5bd84402e64749c3ab5d63a3be98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e42d0d2288ccae90265e9afb8e836454dcd9e1ce627a506194560e1e6db6d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97836444d234b29476d87d1dacb2c610968afea0a7a62c30747b12b75b95dee7"
    sha256 cellar: :any_skip_relocation, ventura:       "68ca4733dbe691a159a0b8440436dcf7894435e9fc6875d145a4ffc44c834650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca43281ae3659e75a5508bc1ca19b71c7777794f9d0aab570da2fc57b4d7879"
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