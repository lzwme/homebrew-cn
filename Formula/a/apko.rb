class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.31.tar.gz"
  sha256 "c270d778e20000d41bf0bd7c36e55737940b0b9885e5c7fc9758d241df89e016"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c37180a1894ce4aefec818733d9719902b4cae61405e9d1a3fafbd1ad92a636b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff4d4fccf6106e4a89ce8409698a5e36a58c99415893d416ccb9b8a6cf54fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2758a05a101c8e94c0b045101b187a5aa1fd26c2645640a4489f82480ea67676"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21b36ed629574205a883cb50540a9a675570ff3b5cfbaeed196991fe284c469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2fbb5876d6bfbe776e677227817576e2190ca83b7451e2316cbcb6e22eb6656"
    sha256 cellar: :any,                 x86_64_linux:  "ced33320811e2fa54c2e1939a87a8346efe7f93076893c2063350369ae16cf8c"
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