class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.3.tar.gz"
  sha256 "926980f327c0a952f76fa0e61af7aa419ce9ef2a1d97f1abfaa8daea55d2adac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f95ba93cbc8c508c24968d0223e87934d09457dd52d4ed8f0c1079133a8624e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f95ba93cbc8c508c24968d0223e87934d09457dd52d4ed8f0c1079133a8624e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f95ba93cbc8c508c24968d0223e87934d09457dd52d4ed8f0c1079133a8624e"
    sha256 cellar: :any_skip_relocation, sonoma:        "40b82480ae7db92e7f10b074a1c67b261e90d292112d9510dd96f05df907965a"
    sha256 cellar: :any_skip_relocation, ventura:       "40b82480ae7db92e7f10b074a1c67b261e90d292112d9510dd96f05df907965a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe957d5509300e9e19ff717fcaba760f92c6c201d1e334f8248bc39f132b0c6"
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
    assert_path_exists testpath"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end