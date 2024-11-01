class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.7.tar.gz"
  sha256 "625be1d2c854f4abd0891b41109dcd2b77b2f16eff34e6ab11257696d75776d4"
  license "Apache-2.0"
  head "https:github.comchainguard-devapko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830ac1666ca205dd3f86a285c836eceac84d6a7048cc82ee53a2e094fea5bed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830ac1666ca205dd3f86a285c836eceac84d6a7048cc82ee53a2e094fea5bed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830ac1666ca205dd3f86a285c836eceac84d6a7048cc82ee53a2e094fea5bed3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a926cdf940305b4da2b270c3db3e7d4ed45ff3970b9a1f1b8f9ffa162090a56"
    sha256 cellar: :any_skip_relocation, ventura:       "5a926cdf940305b4da2b270c3db3e7d4ed45ff3970b9a1f1b8f9ffa162090a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6874344202da3a88cb9ae65186a5ec02bedd61b61c3b2811e5ed0bb10ed47b07"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"apko", "completion")
  end

  test do
    (testpath"test.yml").write <<~EOS
      contents:
        repositories:
          - https:dl-cdn.alpinelinux.orgalpineedgemain
        packages:
          - alpine-base

      entrypoint:
        command: binsh -l

      # optional environment configuration
      environment:
        PATH: usrsbin:sbin:usrbin:bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    EOS
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end