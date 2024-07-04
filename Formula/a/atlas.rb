class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.24.1.tar.gz"
  sha256 "f89f37a4d8348cfe26b571a36e2f05e328e570a9ccace80497e31e9299ab5b65"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39531027450d5be1826abd968d6511a7f1607eb6db5a5d31ca461e78fedc9dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d044d15fc3fedeb1b4c2a8844bbb5498d7b37d1e61259c27845d19bfaa058d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e2aff3c4a2cdb8048c896ddb21340f40256f190a34ab39db06aec9b5f4b1bbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d96906833ee671e78dc6c78612251c66737f0c4593d5177225ac4e8de53daf1"
    sha256 cellar: :any_skip_relocation, ventura:        "5b24e2ebccce2cb37bb9db5e8141da0d0386dd4ea2f0f0d5234b3bf73b7b998c"
    sha256 cellar: :any_skip_relocation, monterey:       "81fafe1c79c8076ebc72a09735b6b7e5118171521a67442fefc827004acce686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48bc0dd7f8a64a7812f3105d959130574a5ca35b120266244c80b40f2246e7e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end