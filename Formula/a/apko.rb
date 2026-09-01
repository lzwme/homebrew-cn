class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "d38960ff2db7e14ca7d8453dd171d8775c4e0f3b1e72c8cf2dd0aaab4d7a2738"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62916ac92332699d12e2b961e7f4a23ff677c67806f5a821d3e10dce3883e085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51af9b4ebf448c5fc4dcae68b6460147b23fb30fd49280c9568ae5d79e26822c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1a9b86d191089daee3b0e43a8e64201577700ce9304c08eab4c28a30c759eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2cbdaefd80876fa51753eb87e2b3e3399c07f8b34a2e1f82df40fa30a248f19"
    sha256 cellar: :any,                 x86_64_linux:  "f4de799f4974916796fb9c9f0680c9d8a870cb315913190d828649a88a19f961"
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