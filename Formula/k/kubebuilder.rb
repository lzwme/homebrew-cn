class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v3.13.0",
      revision: "c8a7cc58eeb56586c019cf8845dad37286d077ff"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6e4f618a714f09092a1af8a6a724c4cb54f99e9cc9fef4e67282638bfa51c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1afdd07e2110da4239322024a413fc5380c67fcb97c134632bb75d1ab37818df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4feb623b22741ad976d921c8d4086b0f0cb47615b5af9ee251f4ad11520c52d"
    sha256 cellar: :any_skip_relocation, sonoma:         "301207c578ffeb9c9595362b17866c3775622344d0a43cb881ef1e27cbc1b5c1"
    sha256 cellar: :any_skip_relocation, ventura:        "d601a8461a38fa2b0f2d11adfda86b7a00d65c6c4f2a65e4919dcc0ff47233b6"
    sha256 cellar: :any_skip_relocation, monterey:       "1e240f8133f0bf58ea99fb91a11af6d72f8ce44f4257680ef58cee8ea85f74eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911ff097be92d1fd34fc6f04aee5a06786e71c88f919b6e492fbd9e31a1bac4e"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmd"

    generate_completions_from_executable(bin"kubebuilder", "completion")
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}kubebuilder", "init",
        "--plugins", "gov3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end