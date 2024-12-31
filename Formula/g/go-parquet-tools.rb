class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.25.12.tar.gz"
  sha256 "a34e545858754ac7ba6e03e0ae51d91dacd21597f59a1fc4c80581ac59b37df1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696c51741a50f9a044235caf80f41df8a6b7550677925793c3ac2e660ceb254d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696c51741a50f9a044235caf80f41df8a6b7550677925793c3ac2e660ceb254d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "696c51741a50f9a044235caf80f41df8a6b7550677925793c3ac2e660ceb254d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0182ea46749b8e6fb0aa7d90a26604cff4bf1c95ebd95cff9dfc48f27125a25e"
    sha256 cellar: :any_skip_relocation, ventura:       "0182ea46749b8e6fb0aa7d90a26604cff4bf1c95ebd95cff9dfc48f27125a25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6be16f611e6db9bcb7b42728df32de3f431fd93045905598a85a5d504a402e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsraw950d21759ff3bd398d2432d10243e1bace3502c5testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end