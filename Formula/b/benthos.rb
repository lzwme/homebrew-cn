class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.64.1.tar.gz"
  sha256 "8688f710d99edfdab5d3c15e7036db1fc557ca946b0461e447a77905a021e3a1"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a68ee82af2c69fcc5f47da5f72ffc54a9ac8ccbdeacf84d850ffffc5d249e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a68ee82af2c69fcc5f47da5f72ffc54a9ac8ccbdeacf84d850ffffc5d249e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a68ee82af2c69fcc5f47da5f72ffc54a9ac8ccbdeacf84d850ffffc5d249e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab1feda4979b5ab2fdef1252c3b29055b9ea236d652ebbb85fd560515821c10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2101a4fb4d455ce076ce97f091788362befc5f68ea4d9b254247cf4a06b17a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f99d337fb8bac37e004e5fcc473528565371b8125069f53768b7410711ff08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end