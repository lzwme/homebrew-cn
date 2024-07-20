class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.33.0.tar.gz"
  sha256 "6a372eda621125863faa1ab7008ae6b9932e46dfb18851f6183b2af67f398173"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50e5e22fb6fd191ac54669e7e38755e0dc879799cbb13d4d98a8c375ae624fea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d49b39123f69d6590eebbda8d8d8abda306ad8247a3516ef39819d030b4c14e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb29263d6bc80ceb001a81bc668bca205ec37c03ff9b44214fa0caf7c6dd5f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff7cfe798d9e4e295ba8ec56095fe3f7c22594551b46ba1530e419670180e7b0"
    sha256 cellar: :any_skip_relocation, ventura:        "48e9ccd60ee7fa8f8fb50c24074a637aefd073d8683548b524de95d1c17e9c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "f80ea6fa946f0f9081a7fb71a7586a971418ff376d228d0141043c794e25cc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99912ca321cc4984f3ab0d6dbe4b1582b89c9632d00ce070cabef58ef6f83ce"
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