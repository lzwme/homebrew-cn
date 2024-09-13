class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.37.0.tar.gz"
  sha256 "4b8ef28d17db3f83ee5db70737b4157ab19310f09369248c11b4f80b0c39a7c6"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ab89ffe3f244f14faaec5e7bce0e1231a79316fbdf129e9455b991628bcef58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ab89ffe3f244f14faaec5e7bce0e1231a79316fbdf129e9455b991628bcef58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ab89ffe3f244f14faaec5e7bce0e1231a79316fbdf129e9455b991628bcef58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab89ffe3f244f14faaec5e7bce0e1231a79316fbdf129e9455b991628bcef58"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d85c4ca070f5d68c41f93da6cccdd960367387d32dbd379db419f26deded7f8"
    sha256 cellar: :any_skip_relocation, ventura:        "9d85c4ca070f5d68c41f93da6cccdd960367387d32dbd379db419f26deded7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "9d85c4ca070f5d68c41f93da6cccdd960367387d32dbd379db419f26deded7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022106c80d6147d3031eabecb5a7e04c00b7f49c1e204c6b932bd728400b0773"
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