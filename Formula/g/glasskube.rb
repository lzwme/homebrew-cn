class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.5.1.tar.gz"
  sha256 "3749ca3289f94ce80bf64a192491311982ce178720b845b2b56ffbcc064297a2"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f70fc1b71148860b207641814647863b8da1032bd566d5bd5019023246ec0bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cc48a4c71f64f640ce8f9ea342c26419630ad992192b45d010fd9cd1621bb85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5fd7d82a35a0152804be50e144809d7884d74dcbba4f70720d262f0801d44d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b7fb31942b6974a75c9504feaacbffa1d6c8e156a4bf4c2e9d3ff1404812cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ec8e85b8f13092e83894f64a8d14bfd1a2c5a989b74e6de3c75055caad810bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "c487a0057282cfa82d03f57809d4095b0a12f43b7e3d2040945e53c61e94ada7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a058a7d981c826f54cbefab06cc8d7beea61282e8bc38662eb434460ccbf63e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end