class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.5.tar.gz"
  sha256 "41597f570e369165d0910ec9200c265fb09d1fd36574e19b4bc1ebd0bf7ee8d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bcc9d2d1a278b84173ae7ddcb00d5183ec1799f3c5554debf2dfa835ac5d6f5"
    sha256 cellar: :any_skip_relocation, ventura:       "1bcc9d2d1a278b84173ae7ddcb00d5183ec1799f3c5554debf2dfa835ac5d6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dddce1da9b6a81999e70d71ca2cc4b159b62e13bf7af579777d6caf1697db09"
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