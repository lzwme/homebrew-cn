class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https:px.dev"
  url "https:github.compixie-iopixie.git",
      tag:      "releasecliv0.8.5",
      revision: "19c6495a66eb3db7f156e954d3c65221dd752a4a"
  license "Apache-2.0"
  head "https:github.compixie-iopixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasecliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f800673e0ba263e23cd6bc4027342448189a6542b7d35a80432bddffc86ea2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3af1d263e2f62822d9012e3c611041a4c8e36b0d01791c06bef1ff4cc504f387"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75dbf0e72d8e6020be72b0ee7b1ddf3134954c69ce0809511d1f19ee543e3617"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9ae0565cc44b9a14810ed1b497caf198d8c728cc8b464b5f410a5fae623e48"
    sha256 cellar: :any_skip_relocation, ventura:       "300665b77ae77cb7f5097d1f3c79ce406c6f8abc82ad9db7f4c66fa4d8aa77b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1590bdca22dd66d76e1baf07a857f5a2369f57573fa1f9817c4c234993bdc2f4"
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