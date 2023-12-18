class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.11.3.tar.gz"
  sha256 "95c644591f54eecfab0ecc136cd53431da0835b22835f15096e242ef2d5b7c73"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8441bbd5074593cfe6590c10e5aef78f2be7282f322b20bcf911795e65e6fa14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07790eabcbc9ab59a6bf256bf169666a0c9b348cb209c0980f0a973dd09ad5f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d8e984bef653997edbf95bc49bab29c33f6dab509b6b8d4e027061fdf9c6e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d25163561d1a71ee17fa050c5e7b21a95079a8747b94da113b73fe5e7961b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "683ad603efd0cb56e03b0235c89f26d665da5dd9903940d2890652f8c9f8d9dc"
    sha256 cellar: :any_skip_relocation, monterey:       "8ce62c4413906a5c6cc838a10d0674841246529946fa2e955fad42cc945cfdd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c99310be48c49de7d9a0bb2844fea08cb87f4ad46d782c01b5b7391a68b59a"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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