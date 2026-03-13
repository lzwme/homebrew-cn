class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.18.0",
      revision: "fde432332184ffbfbbc0e191dae0bfb6498cb4b8"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1787689f85c19cad9225749bc843a5b05ce589f9df6c1ad50b8029425865299d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc13c5995ddc184aed3f311a7ddfa833df76a0394f8765597fe8af36592ccbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf62e52f8aa50fc7c5742fd7a8b81583594eea99d03a891cbaf96975032a8814"
    sha256 cellar: :any_skip_relocation, sonoma:        "3982a30979d8157ebbec1365bd6d13b0dd74ec8f20df38b30f872a4c04cef882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc8beb05712b238759f729b9920010da64017b874475295e90b3918abd5ce03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd67b0f8b2ba6a4368f3d546cc07ffc375019ada0dba4666617cb7e3d4e5e47"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end