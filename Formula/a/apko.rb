class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.4.tar.gz"
  sha256 "51b5d54425a28e07d69af2cf7fff7126c9b864f711e1950f217e421fb041231f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee79239f3ee66db172a2e01034f6f6e55d6108a4fdec649852aa852d26badf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee79239f3ee66db172a2e01034f6f6e55d6108a4fdec649852aa852d26badf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee79239f3ee66db172a2e01034f6f6e55d6108a4fdec649852aa852d26badf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b10e25ea1931a3247826c60f1ad51add2bac0026cf77e426a011c36c40f967"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b10e25ea1931a3247826c60f1ad51add2bac0026cf77e426a011c36c40f967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9edb821e5ba896bd35f1f4e4ff5fd03acf4cbbd91aebeb5a9d327b6b05d6f8ce"
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
    assert_path_exists testpath"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end