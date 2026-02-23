class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://ghfast.top/https://github.com/homeport/dyff/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "cdbf4aeb725e8134b2bf2e923fd192e599f57dd220f4f07ef48a0e7e76dc749d"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd8444f9567cdd51eb68b4a2fdbd2637b49a04c7e10739466a7b0ba29045e5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd8444f9567cdd51eb68b4a2fdbd2637b49a04c7e10739466a7b0ba29045e5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8444f9567cdd51eb68b4a2fdbd2637b49a04c7e10739466a7b0ba29045e5ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c1ff4710e1e70e556c2b8c755a7ca9a9e454eb968fa2655c681cfa4e6ad782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57371e02454e167edbbae1dcfc575f1723b097048982aa12192859a207d85a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55443f246ca34d4a85d6fa6b2dd1a2c1a8f39e5e383b1c3a1e57c68a71ba465"
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