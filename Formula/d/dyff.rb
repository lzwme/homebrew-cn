class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://ghfast.top/https://github.com/homeport/dyff/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "9369237eed57b2246ea5cf155a40b51d19a374b3333400b2c27dda0b087e58ed"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13437928dcb7db405af3c559054820b106788423a3ee9e1297f15bdadf487a30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13437928dcb7db405af3c559054820b106788423a3ee9e1297f15bdadf487a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13437928dcb7db405af3c559054820b106788423a3ee9e1297f15bdadf487a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "a57dac835713300ae5e8e933000e71e257d9a0f50fc7f5d5f9f2f3b56320097d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f00212c3ae9b2004cbedf216c5b7b5084263fdccbf0c8927e068b155b19c43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07990d12963e184a42b788f9eeb722e45900b531fcdd5d6a6ed386faa4766b4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end