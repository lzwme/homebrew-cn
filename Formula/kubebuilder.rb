class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.9.0",
      revision: "26f605e889b2215120f73ea42b081efac99f5162"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af118ea04ec3ec503d79d797562063b427fbc1b7c23a4f5d234bfcc439d8fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d8d84ded09d6f0930e7ed81e46f775507f2df52962a078af421fa63f562af9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62b7dbe83f8cdcd6874c000b377c997352f0aa69186892e7953522b7432bfd78"
    sha256 cellar: :any_skip_relocation, ventura:        "3f988dccf0784d6edc0d4b9463c6c5df4892cb9ddea79e4fbf9bb52155072657"
    sha256 cellar: :any_skip_relocation, monterey:       "71639a600f55228313c89fca35d61a10ad512f2913d5d75a83dbe94e60bede03"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf477bc39a63b3f9b389f59a1db62eec83a5315634c28f01bb776e325a56f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa5b916968af2b81b20947537303dfbd46908fa609ea34e5b6ac7a166c313c0"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}/kubebuilder", "init",
        "--plugins", "go/v3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end