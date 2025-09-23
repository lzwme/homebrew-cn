class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.12.tar.gz"
  sha256 "a18afebd18424d63c011b07941c9283a1bca54ac6135c1e1bac9c36496f9d265"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2690a8104c9a8229e7158e42e2c91575bf7ab1a592db67bab3c917c724fab34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecf6204dcb1c82e4f35cb777ea9ae08ebe32e4a87bb54f256322e63143c8c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4d12bd6e6e5d7ceaad3237bf26bd5e36e3eba0786a639b4440922418a24329a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02824a8055b885788d042c04e061520dd4f37ed73c9bfeee0a23530ec7e375be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58d06ab6f26ee6e7c17d8d736c6b065afd88ae9f708ea92bada8b23d36a1471"
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