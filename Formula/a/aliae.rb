class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://ghfast.top/https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "5a54762575abd7167ba52e7ca06c2dde42962defece63659d733ec918548f9fd"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cca18f04386ab1c61c2dd892967a1f7bdec8ea9a0b87f3e04be319be335ae9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a19a668e7c211026c8095395d163d1a37707b2ea1e672c084950a9623a3c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "152d91a94e6d0d8941b7f5fad81915290ab860a6e960d6fac286d0459a4333d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4543e81b93b3e193ffb818c11de79f2ff3724c661c3dac011ec45db771338f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e068facfd6cfac0b3ef6db054658993b6f7f3ad3ddab7d98f47f998b668f46f"
    sha256 cellar: :any,                 x86_64_linux:  "be42b0a5bce94d44efec96582712a8c5a8497d101381ca8c7c3cefd10e49208c"
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