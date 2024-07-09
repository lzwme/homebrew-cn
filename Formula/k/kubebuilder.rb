class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v4.1.0",
      revision: "de1cc60900b896b2195e403a40c976a892df4921"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62570265b49e55b4fefb6b15e955a92d1b7b080c93b2c3cccfc7acee3ce1ee00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90878c9ccaedbf0e48cdf283e4bf1e3a808ef350802b9a982020e153bdbceb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a0238e67d1ba13e1bed1d92274552e26f24017911f1efd633e898411e5f917"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6e4972266296888f8349ddbe778ee393d875eb1ad37a2407e214d8e330f4ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "0c2c020336229aa10dfe334e59d531335959994c4a98faf022c7b656c55e5ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "8513888911d43fd6169d0a53d8d8cf745426f293aa793f7ea6df1632da54684d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0052136bfff9461de0ec13b1afbc7485d6364578ff463d705f76e9eabc17286"
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