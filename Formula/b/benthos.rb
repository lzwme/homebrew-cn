class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.28.1.tar.gz"
  sha256 "779e59a1c3d53c0cbb49382b2c8e57338022696fdb69f189cd43c36959ce4249"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1b75aaf80a223f491ea95c1e7aeb9d574ca85f1c28b41b2d065145cbac4fbfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68288a4040241b988e61bac7b986995e987ad2017cae7dd4c8e74f2331fdb7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "276ddf50d5396d592cdfa40dfd1b59dbf5ff121c4135edf6e36434c6a6487f5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab1c46e3a2858f289c487371c6408c05add2bc3514f981802cfce59653903a8c"
    sha256 cellar: :any_skip_relocation, ventura:        "80b03f881368fd7aa19b44c612d0b8018ca66d85e86321aed87191527e1ee738"
    sha256 cellar: :any_skip_relocation, monterey:       "56c05656841cfebd8ea985bcb8e8afadd35af49f0efd99e980bdfca3319835cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a487c3250fee43e5a59cd7457eecacec0e3ac513fda195dd4c31890bb0787fa"
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