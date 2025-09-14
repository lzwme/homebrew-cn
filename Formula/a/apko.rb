class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.10.tar.gz"
  sha256 "bc84521f0aee3148833c65203971da001266126ef792104768621794e8e96d90"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90a3b9ec22ee08ab0bc9e046a3fe0e459c3ad697c0a6729ad8ae848934d7ea80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a6d021a50875412e90258ef2cff33cf1e455701e7c30c96e7c4c014057e877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b23e6620515d8cd287531d49d92fbd9ef1b2ad5c231278daaa5dd2ea6dfb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f806b063260a70232b8ded4737985d638655922080e6d72dfe9c60da77ef23cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f31c06dda88f391f890dc2d03a4e1c8c687bcfb757168c80f1bd7295f9fbed5"
    sha256 cellar: :any_skip_relocation, ventura:       "df42408876516fe76f9fa19ac9bf86788edf1e932baba855346b6f3c5ad19028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea732da81dcb7c01f03bb196262e5936fcb65c6912a535f88c0fe1b56d6ccc2"
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