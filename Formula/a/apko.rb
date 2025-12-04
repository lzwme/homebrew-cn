class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.28.tar.gz"
  sha256 "fd9f0ca382115b478744954049d46fa68ca7b9f47fbf47e72a0f04838ffc8fa1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b01800de3323c9ff91188cf892b02a47fb3461816861af2f0b938a169bb571ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67764aa5c3c89abc1fb2faf80d2b745611c4f5bcc963e0fa0b6f249966af9e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50872b8c5ded47391b2ff5c38b755357e06940933c05329460b5be6e0b846bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f46af401790664570febacd4b55b2435a8b706927132be11bd78ae24086543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1510466d7d38939b413dd1dce26b0a4595a3b7a3fd39e9299761388d8fb57fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d126613962a298ea96ae346b18380a6f2ebb910c9a68a8178dff4180582fab"
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

    generate_completions_from_executable(bin/"apko", "completion")
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