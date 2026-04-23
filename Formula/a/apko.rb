class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "0a4983e5f504544d28f0046ccc0c8bce7a6b894242b3cbc5d5e580653a34e3ad"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e75085e2da968919e5965877229fe6ed044d80007510850768e75b843e7d2ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d34abd7994161dff463a22df40e0d391862e8b76db97587866db9a6bf557f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c4efd41b43465739fe97d98c67789325388087d4dc6aa0cc704b495d3834b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df9f5f4129308ac0c4bcb7ca0e35eacff113f578eaefde825b5e02fc685b208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a018156480286f32ca253c3d4ac692e3d1fff24547dd91bfe575b80ad231a3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5895c393bbf97ef1038f3f84f50891b102282a056f71d488fe6e6efafa0511d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end