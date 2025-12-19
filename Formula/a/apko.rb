class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.34.tar.gz"
  sha256 "5ff2e903667148dfab6b43982a254fa51cb9ae63332bb8f9e566a83e4d363a30"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4481ef44b6cd71b88ed93da5a37f8b670d07b32f8e0815fedf96087333baada7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e3f9f41b698aacdff07d267c895d315800d5a8dfbd72ec4e3bf8e87f477ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4d6a413238e8f49ddcd74078f48d622d9d3962a0529ea401fcd33720aa37ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac6796f87ed1379bc1e7f5660d41c6b7e838c284e459f8090a4ec27d2474e864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f41433da57b7d987f0d4d362d7ef59ff2e96437d597ebdf3be64cc0450a6da09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "072d8cdc06f77b76ec44e79aaa464a47c0c1fef9ee05fd5c1bd9d4e8c790c22b"
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