class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://ghfast.top/https://github.com/carvel-dev/ytt/archive/refs/tags/v0.55.3.tar.gz"
  sha256 "ff45d6b34342714223b75a98bf089c108c928b3d8247651c4aa70c152ee42719"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bb45b110a236a979bd0b8abb60f86fd47eb4cf3c7d3b7d3f38c8f4c67304a4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bb45b110a236a979bd0b8abb60f86fd47eb4cf3c7d3b7d3f38c8f4c67304a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bb45b110a236a979bd0b8abb60f86fd47eb4cf3c7d3b7d3f38c8f4c67304a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4b6dac2bf5d452a14d00235627e46e927a6718126874b5f62a0d040cf585b7b"
    sha256 cellar: :any,                 x86_64_linux:      "b75985b270a7cdf962f46ba59a7f2e3047bfec8505ae5f4c92da3d1776b4f6e7"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytt version")

    (testpath/"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath/"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}/ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end