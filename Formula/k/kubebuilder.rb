class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v3.15.0",
      revision: "c01af8fb2cf7c8e11b06b6b491f7974fc1232d1a"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad3b3685adcae3cb5db5f07d552a082564249b5663a82c804e14a75f01c5689f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33dc113672c0e1ced3d09a6dffc479c620f2ac758e123c5acf2282c7453cdc8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c389e43c88018c7d923633acd58ed9fa6ca0b92f12d782f7079bee1e36c570b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c2010bbb8cf22fe812d13d0a828e0b9f745ae5dafb862c00f8c03be2deea011"
    sha256 cellar: :any_skip_relocation, ventura:        "d2108700e69f6de96d310f87c7a46a536ba932b470bdc1e5b760ebacf94a884f"
    sha256 cellar: :any_skip_relocation, monterey:       "2b995ede32cb1f43799ce464e4f7cac8c95b2927289543db5996681d5f0840af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "560822e0f64254d9053f2a11effc8ba56e4b0e8fc02b8b4ee9178b69727f5af8"
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
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}kubebuilder", "init",
        "--plugins", "gov3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end