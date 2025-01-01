class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.26.2.tar.gz"
  sha256 "c5c17003e02377c5edbdfe70618cab03952ddcc4b870552f6c945b3481267aec"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609c6473980f8299cc9e0666fc0618db92e9433e8f6c8d4286a61535d3adfb90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f3b546b391c972066562f44938c3a7fb3d7b43d68e04188cd1256c7cbd7820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b267c5be15d5185e036653c6a296571e9206652fc1599c3c280d15c6142b592"
    sha256 cellar: :any_skip_relocation, sonoma:        "66854ef342dac9bea082212ba64ee9fb73636da571a2bd1787bd7a4238dd5202"
    sha256 cellar: :any_skip_relocation, ventura:       "01e2b5a3060c1a4180631d26dd71b578e3aa2ca952aaae5e41606697b9b1de8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857ffec33e5506747e720bb1016fe4d897b7025ae5e19a36f758cae140432026"
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