class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "23e8bd2a22ad42da8abcbd7e276e30882090b7d099762debecf8d4a8f9acad9a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9121132f67e51572278bc487553f76830ae20e983b596b3da92d25664952f9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d38e1bc4baf10567dc8d9a66da30e519278130a2fab5b167ccc49e6e6440444"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0aaf38ee73eae5857c040546c7d262a278803e04697f1516dd4251e6411551b"
    sha256 cellar: :any_skip_relocation, sonoma:        "16b4d26c1808ab1e92a6caba4c32b9052cc6c0c7499738102f541a576f7dc465"
    sha256 cellar: :any_skip_relocation, ventura:       "ed22822ff493d8980f51ff306ab5de900272ad7d221e60ac241bc0a858d864d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9396c369514957fdb4e608850a0abfa62c7db870ba86c37cde38b5937bc3da8c"
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