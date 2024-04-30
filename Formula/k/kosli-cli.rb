class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.0.tar.gz"
  sha256 "3c135d19615ab9a81c0f7dd3ba69c1fae5f162f3390888c7665b1fa2e3be4b71"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d871bebdec00c7ab874d65625f331fcde2a1940474183a7e91059b6463b21ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fda407ed081fc7cf069fade86276f076011b9e02cad6903a961ba9ac9fd6bd80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d139e211b45d633fbff647d8580f826ba613262101331a3e999f54196094c7f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "371d8420c723f4a6b0e9206bd63251708e43d330fdf4fd9c56361ebf9fc9642d"
    sha256 cellar: :any_skip_relocation, ventura:        "29d35462dff8457ab3a2db992d60ded897d6ef02e6e3767b22a63ccd3f927717"
    sha256 cellar: :any_skip_relocation, monterey:       "2abf2d349e4f39d749074b8cc59b38977fae4fbe98037a324bfc98af94a80a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91de51b43e33a56b4cb5cd520985670b7d535508d6d2618e687edcdb12295d7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end