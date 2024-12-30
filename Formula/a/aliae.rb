class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.26.0.tar.gz"
  sha256 "71d6b0327c3c3717814e37daea55f80c1c04d31c53e799505ed13d75a7f9b557"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0759bb4a19ec6b130896d247b235df5486a43d4c7a8af0a81cf269813705a0b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ea43373c96463b9d5262b23eb1706388d424bb53e7f2ff203fedd8acd9ba1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5030b4d873fb145eabb3d4ce552b253016fa17b7b143187ba89c92dca11ba7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f7280bf8c5dfbfcf1b547a1f0a6d6d06271eb1365edd3e03ca703d7825cb6a"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd45af49ac63184c53f335cf9cd2229323a009dbfec8650bfebef7eb73082e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff633dce774c5f5e571b6a87f14a8e0c6afbc11990a9b4a5076f229bc5877db"
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