class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://ghfast.top/https://github.com/homeport/dyff/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "30f8bf96acbc4a4c0b0dc857e849ca8903cf5311bb7e96cdaf2cf2d4d137be44"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eead1f9d3dea8c612832aad84fa27895a39d0df63f1081f5220d077d298efbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eead1f9d3dea8c612832aad84fa27895a39d0df63f1081f5220d077d298efbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eead1f9d3dea8c612832aad84fa27895a39d0df63f1081f5220d077d298efbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1005be08d8143563fdf2e0cf367e19f7b73a05a38237a2fac3bfa09130c1392d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78da623f2e40e94a78e1c1ec6ad8457be50415d26d361eda1e04c709caef5f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640ebd919f4e3717aaa015cf6c714e0f75229200bf17fcf15ddd93c1dca74ce1"
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