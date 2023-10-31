class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghproxy.com/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "1ebc6897c92fe3bf3d0e6f6c258f9bc859171feebcb936008f53fe6d0bef0a2e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65b793a6d7adf48fc1f24de17873472b1b5f8c3bf012747c597196dfac779d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36d97d3cdafeaf771da0567c91bd5e2f64926bfad6ec46983ddc4e8ccc96457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d51fa38b30e5fab9534cd5bdf4237755fb02f745122baa9332d12bd0050837"
    sha256 cellar: :any_skip_relocation, sonoma:         "70f69cc2626b1603276810edefe39168f498ca75866995a884562b74d6afa9b6"
    sha256 cellar: :any_skip_relocation, ventura:        "cdea733c4cec16b8094119c3f3317ac766460c02ff5ca4f15769de7402c38c04"
    sha256 cellar: :any_skip_relocation, monterey:       "eaea9a434dfc047d68c519c3f9ada6bf63d53af741bcd7eee2eb19c3000a5c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d01b0b5b7c130e832d0c6aaa90311ce52291ce1fe6f42a852530b93bb826e1"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
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
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end