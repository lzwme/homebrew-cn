class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.31.0.tar.gz"
  sha256 "fc9fd98cc558a1c2a81ad32a642c4576ba1afcc3a5fd3e8b0bc219cd47bfbfbc"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44c36976f5e2257e3fc68dc73cc41556765d1571d24090e4a8ce3311060929f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5cb3e7aeedb64ab0b4275d4e1e27cd00db4f717c12fa978b4e682c354d1d82e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161be58e2d69ff82ab6c68dc074794ca4c2390254cea1ab96778f6cda378ea21"
    sha256 cellar: :any_skip_relocation, sonoma:         "20db2228bf01be4d808eb224725ca32401c34bcee7a1455f6074bd1ba838ff12"
    sha256 cellar: :any_skip_relocation, ventura:        "743002db886eefec332d14dbca41c50884984bb6181d441c79ced77459409f42"
    sha256 cellar: :any_skip_relocation, monterey:       "4832be7116c5ea7b3d8b84e222016d4997a32377af2e83cbdcc3656d133233bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f38263504ffbb56b1116394d79cffc63cc70b6714555fc5f1b6a0487a239e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdbenthos"
  end

  test do
    (testpath"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath"test_pipeline.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end