class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.0",
      revision: "3b68a8ea8bf9ec1b6e2af72bdb90adb9f1128c0d"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88bd4dbbcd8cd3b22abf900207b9c829248c85fc1aa1046272111f0340892797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f14115bd91ad95492fd823cbdd63a79874423848f9baf139cee4a609e270da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ff9b519aac75922fd3ffb671801b5b43191a00ef0e2b4caef36b0609d50ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "f319c09f0ce96cd0b0379e155ed5aeed472786af3e7d36ba69c252f2ee9d3161"
    sha256 cellar: :any_skip_relocation, monterey:       "1b91d757481ada070e947f036c00c9c79a220080a5f9501f84606d6ceb60d511"
    sha256 cellar: :any_skip_relocation, big_sur:        "5171c612460148e2517f4aa38c70b4c4404b7fc2a83abbe3306471cc8d290fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83bca464d967a5564514dce8657a63d47fcfabf5ff7465229e538bcc882f5409"
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