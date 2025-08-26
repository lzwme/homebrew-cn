class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.6.tar.gz"
  sha256 "de9bf2fe4db19795c2faef0f17405b861f5b846244b69f18495780ced4d21a6d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449248ff0ed80283fcafafc5f8481a3541dffd0534c7c3b56ba2665a2d77a9d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8a005da7b88780011cb52914dedc87e6ca7aa799497c764d45425fb869191d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e910bb1f670253802a07eaa199adaf7a795eeb8cee86013aed5efbe8daf265c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7cf193fe9c6dc5ed81bd25a6586f41fd198911c5107a9930696b25ba32f69ec"
    sha256 cellar: :any_skip_relocation, ventura:       "3064566ab07b4702e02e74ccb2dddf41afba74e77dd30f99a167218bd4e26c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d7ee4eba330019b2e7fec899c6b87d38aeeeb3349ccacf89f96ecfd4cf4c7a"
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