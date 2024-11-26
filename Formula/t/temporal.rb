class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https:temporal.io"
  url "https:github.comtemporaliocliarchiverefstagsv1.1.2.tar.gz"
  sha256 "24e22de1d36f94df466439b1dd53aff5d4e684e1f9f1da02468096198df493f3"
  license "MIT"
  head "https:github.comtemporaliocli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87aa3cb7ef068bb712e7d0ecff067cfa457b6f0718efc22437aacd4847191c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87aa3cb7ef068bb712e7d0ecff067cfa457b6f0718efc22437aacd4847191c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87aa3cb7ef068bb712e7d0ecff067cfa457b6f0718efc22437aacd4847191c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "567daed499ed1305ecbcc2004c1fd497ac3fe4781cf0f2cfc1162cc4ca6176d4"
    sha256 cellar: :any_skip_relocation, ventura:       "567daed499ed1305ecbcc2004c1fd497ac3fe4781cf0f2cfc1162cc4ca6176d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad94b2004d5a5d5d70d3fd7d8b5853a1665e5571dd4f03319cf30277eeb2133"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtemporalioclitemporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtemporal"
    generate_completions_from_executable bin"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end