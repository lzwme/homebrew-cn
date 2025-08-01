class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://ghfast.top/https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "fa338d62bfdec97065ef5c53c09c35b5ea59b8faa72df79e5e42605219cbe5b6"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d1b788ee5158a84f484792202ea72d73b4556fd51fad894d393f88e4826d5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa06d559a9868f38a8324a23e5413b647d217c778f76ef19c575a4a0b611e38b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91f0b9764befd441d196d19fbd0d9f2e1f55ac5b2a2faa7f90116e5ba5688664"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ad211e96a94cb6a2490418a92e67eda6fb715ebeda097684ebe901d310eb83"
    sha256 cellar: :any_skip_relocation, ventura:       "19d245bea5320f13dbf0520619c3f73ef4e71abaeb24b03cf50df24f37ceb58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d8abb7b6ed373ca63347c65aa90b526c3463042c2d459391243af918cfdfc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2064b98f1cc9b71838bcfc53053e42697016392077c81e7f0fde855380df8344"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end