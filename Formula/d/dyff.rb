class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https:github.comhomeportdyff"
  url "https:github.comhomeportdyffarchiverefstagsv1.10.0.tar.gz"
  sha256 "14a97d26f9be98e4279f05ffd49c59e5362fa2d6804fa54b0f9dc624d9335184"
  license "MIT"
  head "https:github.comhomeportdyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71644bb1480bfa00dcbf95ffe19fab13762b65bf89ec8376f8997c5d16a5d787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71644bb1480bfa00dcbf95ffe19fab13762b65bf89ec8376f8997c5d16a5d787"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71644bb1480bfa00dcbf95ffe19fab13762b65bf89ec8376f8997c5d16a5d787"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d7f3fcf049dd6d871a0ed0d295acd100f59ebb5cdbd34189041be5e484b4c7"
    sha256 cellar: :any_skip_relocation, ventura:       "69d7f3fcf049dd6d871a0ed0d295acd100f59ebb5cdbd34189041be5e484b4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559b783c03afad5742ff656a445947b3a4e586d3e977083f99057488ca3f881d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comhomeportdyffinternalcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmddyff"

    generate_completions_from_executable(bin"dyff", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dyff version")

    (testpath"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end