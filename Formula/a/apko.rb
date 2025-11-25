class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.26.tar.gz"
  sha256 "85090a4b1b7480686f548585273f1bb47adb51116aa0697341eda060aed17cab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2678b5f81d095e3006d10fccac94aabe2958208f7567c96c9dbdd19624f21479"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9943fece50a83b12411a807ff9941ae1352be638549c8419331f5c91f1c323c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661d0d3fdade83561b64089ccf47d814e03713c3a0a8cfd4ce8ecac52538ed0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a47b9e50e6692c092e3c8b3b327daceb1330c7973537471ce21aee6354e1be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51a8ed0e888d5ad9168d22ad0606d9980997c3209be01d5d2b364968a1df38b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad01dd03353c436d27827a462cdae4cd5bda761535bccd424675423a1a6b323f"
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