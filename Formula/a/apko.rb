class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.33.tar.gz"
  sha256 "47c1f7fe924a8e2fa2acf6ea1b7232bc6bfbd6cfe72ef1bc21729ddc68bc95ca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d61c28819b9fbdc62dbc44ada45e64feff094fe91ec6134f020226afc45370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a203e561b8d2a623596747f6af4ff2237f1dbf21ebbac509d370c6486225b0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb89145b4b5c0d4bb23037e0649ce7a917515df94ceb47e0d79c0781f731822b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4824f4289f2f9ff3ac663f9e80ec4ccce800540f0e9c1bcc14e9cd1346d1b7d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6c044cbe66109a5dcb68a8d0afb8302ea079c3ebdc8c89c4019e82ca7bb8f4"
    sha256 cellar: :any,                 x86_64_linux:  "4033f250c1454a9f488c03af23cd8bf018af3ebd1d2b04a02c5af495978c49d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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