class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.21.0.tar.gz"
  sha256 "148c30925c120f005fcf00b713c8f6d024788f9e6944d4042054875f2bc4b2c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0734d55c36992e268abb2a177e869202b17342b2a412052899be9d1da9f8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0734d55c36992e268abb2a177e869202b17342b2a412052899be9d1da9f8c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f0734d55c36992e268abb2a177e869202b17342b2a412052899be9d1da9f8c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81892ae155b4b7d592a595ab86890cd17c39ab94100341c18e9d88618d03dc4"
    sha256 cellar: :any_skip_relocation, ventura:       "d81892ae155b4b7d592a595ab86890cd17c39ab94100341c18e9d88618d03dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1971a1c06947fa1b8e1e565f8f960ed7113b5ed37c3d0ecf204defa41f15f278"
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