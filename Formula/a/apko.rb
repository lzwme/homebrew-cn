class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "543ecdc24e364869e5a99bcd1fd2d66a83d8a6dc8ec74c48e8ffffc52b2d6382"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6bb875c65843a480c252ab8c1fbc7f706a5ce4fc48ef3a7b86570532b0bef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcde71cb0e84a0d6440f25e8804e8cdb10109cd5dcf436c459d18326d274643f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c249eb40fe0c78e25327a1c1aede0ffac949e61e7e0b1ead9dedf9ad7d919a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff925c68d470e7ba1c4c9a3317b20a5ae3b8468e0b135c2323a29f2658f6421"
    sha256 cellar: :any_skip_relocation, ventura:       "e3de4b6097e4e9822bf7940ca644f3a1ef275f08a10c8dd9277adf731855249d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e975ceb843d172ac6de63c21d025823ae659ae52f0e4f20a91f93c1d149765"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end