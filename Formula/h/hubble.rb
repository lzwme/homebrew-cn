class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https:github.comciliumhubble"
  url "https:github.comciliumhubblearchiverefstagsv1.17.1.tar.gz"
  sha256 "fe11595bc7e74d5910abd3beb9b49784d30c596c18be9dac35f8e20efd779b90"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df350c026d1b77b167ebb9b7b8941aac5da17a15ea8962b2e7b71af03e655bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "243a489ac1abb22b64aa3277d5b779bdec114cd8c9fb9395fbcd13b9d89da682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0063ccfba0bb8e912d3af9f52675f0f7ebd0624ef5848c08d635dd57e3bf516d"
    sha256 cellar: :any_skip_relocation, sonoma:        "178eb25894146edc5825051d584ce537422ced196c0e02fc68c15a75eeec1897"
    sha256 cellar: :any_skip_relocation, ventura:       "5e4bdb845e7f8975f017ad7ef2133b94fd73f84552d7a863f248322a1ec98d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78b5f9b7e9870c707e345edea1c146b0c08d3429b7d5597aff9deac11adcd45"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumhubblepkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"hubble", "completion")
  end

  test do
    assert_match(tls-allow-insecure:, shell_output("#{bin}hubble config get"))
  end
end