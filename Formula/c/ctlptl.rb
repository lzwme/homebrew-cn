class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.26.tar.gz"
  sha256 "7b0bb2ba31b7b0e4f8a57e903fccdd96d6281431b4157806c04a8cae87552daf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec7cec557b239cf113aa482b5d030595c9a619733bd10651d567651b58015f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c99ea578ba0280fc0790977bee5d9c10a77f5b8e5588b4c36c99df126cf8e721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9428e92ed037f793c50928930c8a2b35339252e7af13e9e2e6c6018234d10894"
    sha256 cellar: :any_skip_relocation, sonoma:         "567827bff1e860c217d2f712a92933b65bc66da9e56b7ae4ac509a40c9cc7856"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7b5458db6feecbd28edbe464a23979537f0978c4cbeee82dfaed8278e705b6"
    sha256 cellar: :any_skip_relocation, monterey:       "db8d730be29389d1cfe16e96a89691d9bda93d89659ad7653f3d79faf64017ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15624128537a577dafae930a9d756e27c044670af8cd7cada9deb902b916d3a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_equal "", shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end