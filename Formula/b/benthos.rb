class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.29.0.tar.gz"
  sha256 "b8f11472ca806f552a77a152911b0de84ac8c44af07320043acc76b71600e4d8"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3172d97b8632548fc1c786328fff2c8d41e7efbd66f9a74e27536927b81b9432"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5b98a6643e81463694d0d3de2cd3a840435e15018cf2979218af6125dd1016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a745bd75e42114b17d095e95bed618e3af7a4fcf69d92a1bae7fdedc00faad"
    sha256 cellar: :any_skip_relocation, sonoma:         "cedaec0f5b299649f1aac76af7ab4f3339f4d6e0b9ce8d5ac215dae8aa609f99"
    sha256 cellar: :any_skip_relocation, ventura:        "82f7c39ecaf5e9c86c870785bbca3d26325ff52149375d429e0536363040b497"
    sha256 cellar: :any_skip_relocation, monterey:       "6d68255b71fa274c82a0948cd541feaf1b34aeccff4522fa1ab8435dd4bda464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1689abf462a8f0be1fc3a0293d4d96ea81cb8ba94d582b3540396b0cce5b4390"
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