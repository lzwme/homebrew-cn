class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https:warpstreamlabs.github.iobento"
  url "https:github.comwarpstreamlabsbentoarchiverefstagsv1.8.1.tar.gz"
  sha256 "819ab411d01e911620d85cdd7aaaa5614e10d5bc0455e8e6478d72800b4183cb"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39333cf8839d3744dd150c931b0bbb3edf699c85c84ead51ce116bc355f07d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0868adc0786845615bb2e67b3c93d79bbacf96412d025cb4653d74fdd83937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c640462164e09153ee415740f7d98c16410c213bac0b74a827f0bdbda8b510f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c93920828f5d723f783a9389c480f9d0613644dc803e9aa868629a0149c2ea"
    sha256 cellar: :any_skip_relocation, ventura:       "187f832aefeefe5b845df3849fd67221c487caf837518fa056b0ea1f83eed14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a86c2b4f2eb47c81ca7b410ab6a1dcf8637891c531a7757d03dff66a6fef5564"
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