class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https:github.comgooglego-containerregistry"
  url "https:github.comgooglego-containerregistryarchiverefstagsv0.18.0.tar.gz"
  sha256 "f43fe0dc9830a493d5af9dfdffbdd6910a5bf55f5fd493adcc59bd4da857d5bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5412cc8c5906e8b458589f1857a727b116d7133ed841cce8692383e39b25c58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665de4e5b467dea8c17d8d1636c5831cb4706f0c529543bd040cd5f90d138b5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8912c655c98fad071ba189b735ead9c084938f835de4d24eeb1c5bed1023a6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5da8bd08a66cc5932065f93725dad3a28145fc7167255f0064f547039139d505"
    sha256 cellar: :any_skip_relocation, ventura:        "899684b33c7a2bd9f5d3e41172629347da34ff71cbfc8264d13560725821a7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "fb4db7086bd4b132a3b9b26213d2bde44ced44f06ff2e2926d2d5761ef053684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e211f0465b9392ea8b721c4d524ea97df0d3a465c0fae8de03404258822f00a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgooglego-containerregistrycmdcranecmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcrane"

    generate_completions_from_executable(bin"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}crane manifest gcr.iogo-containerregistrycrane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end