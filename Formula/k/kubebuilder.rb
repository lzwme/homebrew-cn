class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v3.15.1",
      revision: "01f76cf67d89e32167d35b6a81b05d21b2c4febf"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bc03752616a2f4029d6d217c435d97c658d7afe77e885749229797f675810c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e720f0834b6e8443d618b7ee7cdf64fb81fec19b19ff783cdb5dd9ac0997b94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2241eaf66b7d1d947f82acd714301fb2fb69634449e86f4c312827d582095f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b7503a97f1eb00b83df1b2483f122941697fcb817b29ac76d206d83d53f046b"
    sha256 cellar: :any_skip_relocation, ventura:        "8a47cd033a3d5691ce2e92019feb468060bc6178aec3f17288109a564d6c116e"
    sha256 cellar: :any_skip_relocation, monterey:       "180ba730a92f888b8da1234c56aef2970cd4b1d8dfe53f3db206d100b586b8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7e050c13710d7caf2bfaae8a5a930822812ebb79299817e5f04f1f08a86261"
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