class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.7.tar.gz"
  sha256 "cef93f52be63c2fda69da5c08aeb185788f0d66a747d8e56176bb6b72533b9e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e100cb3fdc0884b811030bff4f28e7867db5613aadea23486b0edd2cecd45c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f6e34f397f92a391deec496bab8e8dad020876bc222ac76bf0d8a9421eb5f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "276e62582b7a6d17ff70c43d82b465932d06e33ed6515074f242d95f7a6996c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da47aed50cd74e3c5f16966c479e044aae557381b359e1df1cb115f4ccb8e16"
    sha256 cellar: :any_skip_relocation, ventura:       "474f397c89a5fe6b76f83ecfe86c63f6238e1e6930d3467a611db0e3f3d9eb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbd62d84bc6118cd918febf2ac22cc6189ffce621ac550cda121afbdcaaa8e1"
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