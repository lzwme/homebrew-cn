class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https:kubecm.cloud"
  url "https:github.comsunny0826kubecmarchiverefstagsv0.32.0.tar.gz"
  sha256 "04c02f84a479c4244784195b3623c5c9e60e3325cbfa60bd1ce7b8607ef9266c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be3f6a485d74bb4c2fb53ed12b05e456b7ed7c90029b30e4e268420e5a8e9966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3f6a485d74bb4c2fb53ed12b05e456b7ed7c90029b30e4e268420e5a8e9966"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be3f6a485d74bb4c2fb53ed12b05e456b7ed7c90029b30e4e268420e5a8e9966"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7e35e56b2c052a14a73ee8c0cb6c99ab8dab73c91b74cce2ad58861352ccf1"
    sha256 cellar: :any_skip_relocation, ventura:       "0a7e35e56b2c052a14a73ee8c0cb6c99ab8dab73c91b74cce2ad58861352ccf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cfd5e77cc71565402866bdae608944dbd8efc1b1a1a17e7a1f0010f705ceae7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsunny0826kubecmversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}kubecm switch 2>&1", 1)
  end
end