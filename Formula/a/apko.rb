class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.5.tar.gz"
  sha256 "4645378d99c1430836d3c254cef8eb5bb267d0ba881c6667cb1fad69cee6b5fa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a896bcaf5bf74ae326f5b3ec2ce4d3f6b7add7842101ef87dba2ca0840872668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3465a5d0e467539902d319cba695774f4e0baaa3541a88565c2613223b6e9baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17fb89e548431f42a7e5cc168439c69d728b0872993b0b039c007cf8dab27924"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d509bebcd69fbd2392ab53de372276670f9c9f10b774615c90051caba34f6c"
    sha256 cellar: :any_skip_relocation, ventura:       "b8e4791e6d3b652e5e751d992d803b891b55546f8d62c9b23aa4715213582926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef265f5d0fab9772889ac839649e0459e4d59ad7e779ba98f4faa16273b1e55c"
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