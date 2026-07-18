class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://ghfast.top/https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "aab1ea50431610830c6b4152483a0dc212ae5924059a32521187640a9fc08cf2"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf88c359037240b87c4476e2e3c6137cf7be74d136557c600e06a978d00ef5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57add13577c9558980922c568e4142b54ada4fc7e092ed211d670fc9d5784042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "745f19a785b90768c214438de60c6f44331fcd1dbd978436a962c4251edf7648"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c12568545390039dbbc406c4c036876310c6d7a70b7a29b16b35cdcfd5519c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd66ec0ea9090d273bb0dc95209605bafcdbe07ca4975da98f0a0f3080e87d89"
    sha256 cellar: :any,                 x86_64_linux:  "e204a019563a0840f74946c3ecdafc6db8b4d263344a5675086c92dd3cad7078"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}/aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}/aliae --version")
  end
end