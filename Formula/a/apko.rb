class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.20.0.tar.gz"
  sha256 "3f39e793b8f4a7d1844b649729ac997fb46df84ba3b9f14374b9e54b977ef27f"
  license "Apache-2.0"
  head "https:github.comchainguard-devapko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f48dc2c160c621b1a77c44350ba0c07687af4cf3bbb3f83f8de4bafaeb390de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f48dc2c160c621b1a77c44350ba0c07687af4cf3bbb3f83f8de4bafaeb390de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f48dc2c160c621b1a77c44350ba0c07687af4cf3bbb3f83f8de4bafaeb390de"
    sha256 cellar: :any_skip_relocation, sonoma:        "33a5d1fa0bde242e18885b9679e9ea1e5f96dd86917690a641fe5ba88ea15233"
    sha256 cellar: :any_skip_relocation, ventura:       "33a5d1fa0bde242e18885b9679e9ea1e5f96dd86917690a641fe5ba88ea15233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e65f90f18a1d44d0794bf120b72e88a710028d4bb74931cd1f8b0c5001e89f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"apko", "completion")
  end

  test do
    (testpath"test.yml").write <<~YAML
      contents:
        repositories:
          - https:dl-cdn.alpinelinux.orgalpineedgemain
        packages:
          - alpine-base

      entrypoint:
        command: binsh -l

      # optional environment configuration
      environment:
        PATH: usrsbin:sbin:usrbin:bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end