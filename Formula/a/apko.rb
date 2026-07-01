class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "2a903be7f6b27248a3b6d66944975f103b8a93420f93a30a5e5fc1cc6740278a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85dba9abb88251e152256e257632843cba76d4871f85927057605acd3c12c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5deda6eabb682ef3c62cabb823716ad1be7851e4b814622b66471b5defcd48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b54ab74675f85958d3526c9972d3b7b3b7905cf80f816ea128bc7324f85679"
    sha256 cellar: :any_skip_relocation, sonoma:        "3371578b9bb0b2ec34015b5b0c3d24e4a549c37070ae98e8a3299a3fac0b66b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07380fec646e0fc1685b02f0f29435d613811c2d219d84730834872fbc4c60b0"
    sha256 cellar: :any,                 x86_64_linux:  "a5107d0b765ec18c84256132510f107f9fcdb786bfa4817043b2220ad3818435"
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