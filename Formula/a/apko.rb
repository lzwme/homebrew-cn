class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.20.1.tar.gz"
  sha256 "0cd156f9a7a9ab5597f5a605975471ba59b44a8b9c95a0b64eddadbbc44fee1b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b55cb44588c43425599566c06ea38f279e735cb95fc95a78bc36b8885e999e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b55cb44588c43425599566c06ea38f279e735cb95fc95a78bc36b8885e999e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46b55cb44588c43425599566c06ea38f279e735cb95fc95a78bc36b8885e999e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb41f9acc083d5fe11d140900ee122f696b329df6eac01f03267386027b666ed"
    sha256 cellar: :any_skip_relocation, ventura:       "cb41f9acc083d5fe11d140900ee122f696b329df6eac01f03267386027b666ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9a8fcf876634aa9975760f9789312be884eec4c11ea7aeca482a0c985511b3"
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
    (testpath"test.yml").write <<~YAML
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
    YAML
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end