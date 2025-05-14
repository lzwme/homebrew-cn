class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.26.5.tar.gz"
  sha256 "dfa9ce6608ea3d94584e4a47c6568a90844dd9d8f3fd35f8e893fa7fdd5d7bd7"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7758e7e09c133bb4754fdcac53726583c0f8d27bd11553768212e87eba62026b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7758e7e09c133bb4754fdcac53726583c0f8d27bd11553768212e87eba62026b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7758e7e09c133bb4754fdcac53726583c0f8d27bd11553768212e87eba62026b"
    sha256 cellar: :any_skip_relocation, sonoma:        "519c8688bf5c29924491d87f7c323dec8104d2a0b68f82d5c5df11a89345d395"
    sha256 cellar: :any_skip_relocation, ventura:       "519c8688bf5c29924491d87f7c323dec8104d2a0b68f82d5c5df11a89345d395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf8e9cb061d52938211963f94baa609ed43d33ccee3e8b5f9cc70e48cfa25cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca280f0077e0c2e62ab224b7f3102b5faa39aa413bb5db455229debaf1f9f27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end