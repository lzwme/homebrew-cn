class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v4.3.1",
      revision: "a9ee3909f7686902879bd666b92deec4718d92c9"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee4f57443c4f474f3f11e02760e5a569f41ffdc7e43b4ee20aff2ebb401712b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee4f57443c4f474f3f11e02760e5a569f41ffdc7e43b4ee20aff2ebb401712b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee4f57443c4f474f3f11e02760e5a569f41ffdc7e43b4ee20aff2ebb401712b"
    sha256 cellar: :any_skip_relocation, sonoma:        "04a88935b8f844e6c9c7150e0cec2e2949a033161b75224e5ee3373c97a7d056"
    sha256 cellar: :any_skip_relocation, ventura:       "04a88935b8f844e6c9c7150e0cec2e2949a033161b75224e5ee3373c97a7d056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eccaab58c93d975cd255be39ca10c2181a1543b1cfe3f376c7bffb28d21330c2"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    generate_completions_from_executable(bin"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.iov4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~EOS, (testpath"testPROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.iov4
      projectName: test
      repo: example.com
      version: "3"
    EOS

    assert_match version.to_s, shell_output("#{bin}kubebuilder version")
  end
end