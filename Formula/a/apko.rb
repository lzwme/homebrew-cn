class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "03e200352309cefe4dbf3b39c286067d7d6ea7264088726201600832af4dbafa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba3aed9c61ef2588e0e11abaaaf0ff5c43306c4ea3dc506aabb2a81ef6657479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd60ef4640b5cc133e746c1b98d0a6a4ddd3df41a2c08dfd75069039c3ad7c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34ed5fb0ef3a28fa80d2e47aefffdb9e6cb23784931e2cb82d600860ebba07c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d7a22bc2bcfbf2182f9be3c12613912340f01abf379832ea32d2ea2266a27e"
    sha256 cellar: :any_skip_relocation, ventura:       "8259e430c35ea6a09263bf10652411122d5dd3ec19517bf30648ced5df305ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1122aa42c79a3e51ef4dba5c6d771e5b541cd75ddb18f8b1f0fbe37e81cdbc"
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

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end