class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https:px.dev"
  url "https:github.compixie-iopixie.git",
      tag:      "releasecliv0.8.6",
      revision: "fb9de19c8c8d89e069b19a46134ad5611bd8c864"
  license "Apache-2.0"
  head "https:github.compixie-iopixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasecliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f84c71360d5a2174fdbe86c2e63863034b8f3e2462d43b50e044cdf82d92436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bdb8c3169394282b80a07106f30b99266f15a05c2335a8a6543efd76869597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cae0b41e59dd379b5eef835d0ccc19a81bfe360718d735d98aaba0240676e13"
    sha256 cellar: :any_skip_relocation, sonoma:        "259ad6c9723c45287c23b968199cff6156732721fab9394a2c0c95b5dddbef81"
    sha256 cellar: :any_skip_relocation, ventura:       "060cb1446cb43e2941c5b8d8f4de0899e03313925d2527690050be9984fec607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5e89590134e63b06ab9134f0d6d6d0fbd37a3104b18513c5649abdfa19f262"
  end

  depends_on "go" => :build

  conflicts_with "px", because: "both install `px` binaries"

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.devpixiesrcsharedgoversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.devpixiesrcsharedgoversion.buildSCMStatus=Distribution
      -X px.devpixiesrcsharedgoversion.buildSemver=#{semver}
      -X px.devpixiesrcsharedgoversion.buildTimeStamp=#{time.to_i}
      -X px.devpixiesrcsharedgoversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.devpixiesrcsharedgoversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"px"), ".srcpixie_cli"

    generate_completions_from_executable(bin"px", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}px version")
    assert_match tap.user.to_s, shell_output("#{bin}px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}px deploy 2>&1", 1)
  end
end