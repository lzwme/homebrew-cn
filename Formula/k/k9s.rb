class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.28.2",
      revision: "694159b857314de5b69f251e42a5931f32105cb8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd35db638b0cc2d7c22760fdcd19cd49b4981e7e00c90ed948c1d2358da2bea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf1ac2e450ff79f4070a6319e70bb795c738dfafe054625c19b914d0370a430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a64a9047fe4c889bffcea17052669de8d0d6e2e154104baf01da18ecdebd0bab"
    sha256 cellar: :any_skip_relocation, sonoma:         "85b52f0af3e114529d328aa97e302f1951398f951aa1a4127ccd6f369c99fb8d"
    sha256 cellar: :any_skip_relocation, ventura:        "bb87353af47c39105623c445998044e94b402be24ba0a6a5ff5b42666958b20b"
    sha256 cellar: :any_skip_relocation, monterey:       "54060af4f5a61581206a969a63bb2dff405bfd5195679134908d8169778b35d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fdb21eb231aa243e0c21896b7c62b9a742ac1e424837a57a1e89d7dd439486"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end