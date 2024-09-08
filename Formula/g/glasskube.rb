class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.20.1.tar.gz"
  sha256 "c47510a1d7f0909d77f36f048c45ba09d3f8bfc9fc23f8beec0b35c2a297c6ec"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15ff82c77bd3a8286058ec387f54c6f0a101baa4f7e34ffdad0729e07cdc2c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, ventura:        "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbc4025d6e283b495f27eb9f00037f2eee93646fb4038957e3a193d2ac69204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6afe0a108a5d3995f0e07e8504d9514f1dc56cdffb012cc07f2823df02d14217"
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