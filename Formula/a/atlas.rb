class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.26.1.tar.gz"
  sha256 "c74ffe85df472991d7df816d0017ff3b7a95966f2b53859936dc7341f0d326c9"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83e6cf9141443a40ebaf7fa7c5eec47ca38d6378a7a371158068ed47136b02ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ba62af2a613ae5a288e962ed4eab05e466069c912ce09977f3882f6ee442646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b817ce77209dbadc1485836a7cd3428b6e27080fdb63f4946ed98925f156e6c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "df78ccf05aa330ebb18d0559b5eb29a11a7473adcacd03c11b51afe76f4f08ee"
    sha256 cellar: :any_skip_relocation, ventura:        "59c70328a5c94b02dc47e0c1ddf391a11a6a0ea4c9ad86210c2bdb11d67869bf"
    sha256 cellar: :any_skip_relocation, monterey:       "fdbdcd7df3aea7309ba5f8e882e757b6c8bd90a03ec575fda68fbf48283675c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848f433e2091b93d40edac781620291f1acbca5512d1393cff4b3f6ce5bad9c8"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

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