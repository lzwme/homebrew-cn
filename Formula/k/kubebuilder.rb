class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v4.1.1",
      revision: "e65415f10a6f5708604deca089eee6b165174e5e"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "099dcc7159b165f12b4583c24c9b974da453f07f48563d67b58ddc15fceed668"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad98d55338b8614e76eba8bb5fc3ef79bb971e304d14b81f12e3589f2aada05f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e0ffb8028616f6a3a70a58cca2d31b418a14212167f7a937049a4709615dec"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cd5d11f16569ebcdc1fde26d0e6fde591e37c6c826b51bc9a6670be135d4695"
    sha256 cellar: :any_skip_relocation, ventura:        "059aec8f7a4fc143fa3fbaa32b44a9c0142fa7d6b2bfea7220cbb3837179ed8a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ee6a14b27bfdc6b106dd4d6c93f464e7b03c7908274656532bf818b84adfa1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2212c27935a4b708c8bbfaa1bf0ec7a6562832a7d4189e2b0ee6c4c21aed69dd"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    ldflags = %W[
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