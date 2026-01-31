class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "60787a09ff3e83e31cf07b050b4a80dc7006d29edd4c1b1b9e69bd6191d26f73"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7cff27682c7cae7b3516c30a57839433afcd57e59262cd6ef488b998834efd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66d486e8595c5b2e08bdc0d1009d48266ec24a9be931974073ae9b32d32df9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36d867daff6c99574a372c6cfc6b644e6f4f1f4417eea13384dc362d7dc6b821"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c9bb87e214e9f7045b6171b83b0c742575440736f0fbfc01ccf24986e4278a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9f992b0af0a7782d379ecc4135257db2ad456de4e58c4d064354ea72f589de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84970d1805133dffa72b665af6079e14db2314e69492efd264fa1d0f14164f8d"
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