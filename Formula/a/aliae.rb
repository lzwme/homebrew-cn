class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https:aliae.dev"
  url "https:github.comjandedobbeleeraliaearchiverefstagsv0.26.3.tar.gz"
  sha256 "adc8ef4dcdb8a0604c114453a965877158e8d4bb91ad41acb10f58fc1f23caf5"
  license "MIT"
  head "https:github.comjandedobbeleeraliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab29877e9053b99c52251dd4e35fe43a9979f9d87c700618e9291b573b3db28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97566def171cc266dea835f09fef0183e057e5ee30ba02589962e0767a422a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d96204209ca150ee96bab75ce270dabbd14f97ba80e6f6cc3707b15be75d7862"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cb7d17299164c79b339f0d1902ab300ef5d9eecbaed2dbb427cf92718c4133f"
    sha256 cellar: :any_skip_relocation, ventura:       "15d6e698589f35f3e99a69f2c800056caf03f4293683686a3b6ef6b1c3287aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e883ce7e9f53f6a0c2e2f1aff9ccdd7d0731ca81e09788e8f29e537e9313faf"
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