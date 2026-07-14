class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://ghfast.top/https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "18cca0f0bf38479d39c51a9f0ac8a73b4a1c903e03e09c7d73d262ee6905f082"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "061546b19e4b85f7d4f3ba724fbbb704a3f3f9ebe517c9c0f8af0b4cb2ec2427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff7d10794e1accf22b16d266cff7a7548ff322cf9b92e448e77af79e164bb03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f3e7435952257a1de7b6461903f09acafa915781bdff16a29a7af6479e26530"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6912d362c10ed9c380d1c45b91059f37d35aec17080a6b1c54f7755721487e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c07d2e998145cb7fcd304b36c110247a71c4b175b53ed2e2b9b83671f7391f"
    sha256 cellar: :any,                 x86_64_linux:  "49e9e00f9aa7b9ff3f9a05d824fb1ad9929103485d8accfd774e2f5c827af103"
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