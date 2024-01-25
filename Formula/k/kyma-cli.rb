class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https:kyma-project.io"
  url "https:github.comkyma-projectcliarchiverefstags2.20.2.tar.gz"
  sha256 "f928b90913310297d3aece93c1ed06a9326253e17659fbdb9d9b982b80aba921"
  license "Apache-2.0"
  head "https:github.comkyma-projectcli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91fd78b3de6dd309903478e5e6daaab3857c8aeedce8a9d074790b725e917502"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bad868254a613c9dee29c429816e82463bbbb761825086111eb5b88176cafde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be9404a339c333c963aaa986a10016514fa37c20f3fea9ac58c80773af0bb20"
    sha256 cellar: :any_skip_relocation, sonoma:         "4745f589234f244f2718b2b874542cbc0d861aec47803286810022831e860e52"
    sha256 cellar: :any_skip_relocation, ventura:        "732a730b2d9dffbdbcde5b7247301d31358864ca883c8deba985f77298ed8431"
    sha256 cellar: :any_skip_relocation, monterey:       "df6edb991a15688c161ec3ddebad96b7d4ea5e56be3fc63b4fbf7c0daa28beda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "704b9477f59474b16493aa45da15cd23a64fe96e4b8399f4e58bc73d1ae935e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkyma-projectclicmdkymaversion.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"kyma", ldflags: ldflags), ".cmd"

    generate_completions_from_executable(bin"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}kyma deploy --kubeconfig .kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}kyma version 2>&1", 2)
  end
end