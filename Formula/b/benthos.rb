class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.45.1.tar.gz"
  sha256 "eda6ef4ef9c765976d47653156a2d9353d4d0febaf3bdc071e864e3071707a6c"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb88d29f617933a0f508f6430c3863be877223759cf5d7cd3920b5002fef1065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb88d29f617933a0f508f6430c3863be877223759cf5d7cd3920b5002fef1065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb88d29f617933a0f508f6430c3863be877223759cf5d7cd3920b5002fef1065"
    sha256 cellar: :any_skip_relocation, sonoma:        "490999a67e84e5e5f859261b8ea5ea1997b316b515c0a184f19cdedd27a680a4"
    sha256 cellar: :any_skip_relocation, ventura:       "490999a67e84e5e5f859261b8ea5ea1997b316b515c0a184f19cdedd27a680a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a16749edc19759fe56b5beaf9f561d3207d05c73bf7dd52b672d6d2708ba8f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdbenthos"
  end

  test do
    (testpath"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ .sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end