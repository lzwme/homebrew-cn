class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https:github.comciliumhubble"
  url "https:github.comciliumhubblearchiverefstagsv0.13.6.tar.gz"
  sha256 "d8c18e07c8a374145cf0c013eac39d6a94ec69ae3b792542266e1b8955775f24"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8dabd9456a792b72828dde8422d7188ebfb685f124c80d170e840e7806a90f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b4e96373d8064649dcc46f157f5a4a149d99d3b3a037f90812495bb7a6d45a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621cd1c5f825c07dcc18b51311f867ce30a1be5c2a02ef134209b7db50612289"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a9846167f43111a8be6690b2a3dd00d678fe43a63a551caf8ba97caa3f5a1f0"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d6bf86c43057c4ab49ae5e799d268fdd63cd70eded174f53bb4700fcd5347a"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed069a53e31db320e585b6802e6ed1265ca6561e3fa47cac6ea3cfbe6429916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef59cfa04fc0f80cf4691dc94ab738b6912bb903b85112e26a020fd76792935d"
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