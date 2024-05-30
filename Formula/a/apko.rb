class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.14.5.tar.gz"
  sha256 "c6cae0d5cef1fcec11043c82681391f23356b42ef3102273b3efc6b35977bb70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a773351a58a3b66706e062e547c0cafad7c683748d1597c8a6f8e052733b699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3477f620adfeec8d2d46d0a78adc6bcbb479381f4dedab8172cfdc4cac411e1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46faaff0677e7ea14ed04c716333f36f7a252c871579bf3dc21dcdd8d71bab97"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b1dea0986b1a484ff6b0388be9a021de11f22dc923f9b0fb4884cbb9053cb32"
    sha256 cellar: :any_skip_relocation, ventura:        "0fbf5c708ed9e392d39a069940542e41f3950c52bb313cdf7c5b190c4de7089f"
    sha256 cellar: :any_skip_relocation, monterey:       "c928ba772109a32d46692e065af39faddd30d47329848fe99e7b77a9f2c73355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e79b6d770647d4bd7457f688c7d205d8a1836d51a26eaf971fba9052bcdc06"
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
    EOS
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end