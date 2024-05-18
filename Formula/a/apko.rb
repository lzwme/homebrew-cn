class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.14.1.tar.gz"
  sha256 "5aa15316e6eb54474d7177145b7a07949001246a6689b120df551a8b1faeb3da"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e53a0ce8cc1752880192f1f09253e10b2376f5274e3c267a10cb326ff6e041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85655e060831f23580088975fea5d19480abb346ea68a3d9f530735198540672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32ceafda30436ca8d1359de695e3410c5a1f65b58aa9bab3d96868ed975ec159"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9da8283b6459e7dadbcb9c700aad00cec3063aa2cc80ee10fd56dd5d3c89192"
    sha256 cellar: :any_skip_relocation, ventura:        "75a1f2ae0b258fdb18ea658b9487d00e2007aad57e0bb73ad7b62d8a0f3e80c4"
    sha256 cellar: :any_skip_relocation, monterey:       "021428f47293baa1d7195f8a947ff65521937e788fa4138a54134280674ceff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70013fff21b718eba863c5e044333dea3f379926839543db2aa04e04c9a7c5a"
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