class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https:warpstreamlabs.github.iobento"
  url "https:github.comwarpstreamlabsbentoarchiverefstagsv1.8.0.tar.gz"
  sha256 "71ef02ede93738288d97cbacc3629bf054882d27e8edf81eadfe2924b7105f24"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "814d36da40ffcb1c12a05008afd07ef0cb8a7f2f3e4f4fca5c5f7952932f1f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3898927d841b207d777a10f0af42552262e4fa4842813ce1b2a17730223ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55496a311b58d5c39480f57d12ea473ef302a4fbc590475edeee768c5896f55e"
    sha256 cellar: :any_skip_relocation, sonoma:        "017d4a2d908b7061cd3c988c7bfb3e38e922f312bcb29f31a1f46854a2552301"
    sha256 cellar: :any_skip_relocation, ventura:       "10b357ab9c674d2e33ddc0566d52469da6414535ba8b526ea61903fdfabfff54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9e6a505aface1712ce72091564df402aa7a868c9e6f42ed3102e271af3bc88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.comwarpstreamlabsbentointernalcli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdbento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bento --version")

    (testpath"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}config.yaml")
    assert_match "FOOBAR", output
  end
end