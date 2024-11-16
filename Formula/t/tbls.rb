class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.79.3.tar.gz"
  sha256 "da516643223fb63e24479abe6d51f73cf6558749ccf07e3aae263d489efda7a6"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85aae7f1699d8d989a642568597a66eded0687c0f3742334903e0d06945469a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b23803b58024346be76b51e11bd247a5611ffff4367ecd35ff35e0d620a5fe75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "148b379963d2f68148854162b96006c5f4a7a6c433796b0c83a6bd825227a90c"
    sha256 cellar: :any_skip_relocation, sonoma:        "efee0b946b3fbb28ff6363d3e4fbd900e8eac5368c56e52093f4f4555a6e110d"
    sha256 cellar: :any_skip_relocation, ventura:       "790520341c8eaec7f9e52cb689b29621bdf4b6228f6a18794091d37eb42981ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29c7f89b3600a3fea743f8b8616516197581db49b0790fe54b61c8e3c571d75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end