class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://ghfast.top/https://github.com/homeport/dyff/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "07ab1b365f876f92121ef5aa010de26f13a5bf495d29ee886d8781051dce3ea9"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89616cf6c38258a497945df4a8dc78520bdfda7f855fd8ef9b589f5ffa149a36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89616cf6c38258a497945df4a8dc78520bdfda7f855fd8ef9b589f5ffa149a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89616cf6c38258a497945df4a8dc78520bdfda7f855fd8ef9b589f5ffa149a36"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb9949424ef87bdf93404b60a2aefd7e594312d4a12199520b4c220bf5371f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c04e9fdba12c788168a826cb92bca1599c354f8bbb8f41241a30e7b45dfcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b638ef733d87df5abddce32508d66262d24dc8f77525a32b0c6327e6aaada2c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end