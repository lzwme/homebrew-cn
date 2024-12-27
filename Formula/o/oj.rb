class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.25.1.tar.gz"
  sha256 "b94977f7f7e67fe306fc2ccb949189741f88a3490140350d15f4d1eb703e0c7f"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dcd701a8180af1b664c575c86ffc5f4f84f5f7ee484aad6701b050ad1bbff8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dcd701a8180af1b664c575c86ffc5f4f84f5f7ee484aad6701b050ad1bbff8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dcd701a8180af1b664c575c86ffc5f4f84f5f7ee484aad6701b050ad1bbff8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8c3672931c914feb0061933768fb6464d798f5948f3ecb3196d0d8c2027cf6"
    sha256 cellar: :any_skip_relocation, ventura:       "3e8c3672931c914feb0061933768fb6464d798f5948f3ecb3196d0d8c2027cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea99eadc4c69c5e39dc0f9731280fb46c3884a4c9725906d4ff2369821d204b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end