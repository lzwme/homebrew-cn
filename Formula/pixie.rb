class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.1",
      revision: "12308c6ac140554eb63dc02f3f44aa7c308ac1ab"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "217df9012232c64f6e900f2a7c1862b883d6646fe9f65bcf40ca94d153b9697b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc1dcf3496841f22159f1ed5e7076c46fa56092ac55ff233da5ecdf4aec16e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49d7c29355ccdd345ed0a3ea353606f1677dac8050eec30513e969e3c3b34716"
    sha256 cellar: :any_skip_relocation, ventura:        "a25e208cc2f721297231ac5ab9c4a5e6e0febca008b6eef70834eb2ea5369981"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a348d9b6667bb22059c1a3d4b263fb9cf04a3926db25017e6be20e60883cd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a9dd04322b3d7ce89888e21eeb6167922cb47da7e29261139407f911b402d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc3d1453b0bf6232778f66edc7ec0d36a48a5b0fdf53a2655d4ec5d3e171560"
  end

  depends_on "go" => :build

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.dev/pixie/src/shared/goversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.dev/pixie/src/shared/goversion.buildSCMStatus=Distribution
      -X px.dev/pixie/src/shared/goversion.buildSemver=#{semver}
      -X px.dev/pixie/src/shared/goversion.buildTimeStamp=#{time.to_i}
      -X px.dev/pixie/src/shared/goversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.dev/pixie/src/shared/goversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"px"), "./src/pixie_cli"

    generate_completions_from_executable(bin/"px", "completion", base_name: "px")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end