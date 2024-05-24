class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https:kubecm.cloud"
  url "https:github.comsunny0826kubecmarchiverefstagsv0.29.0.tar.gz"
  sha256 "05230e893ff0c989c4429ced3c1dca9b1590e2b54701966f68d57fac65d8e11d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "534609622a7a10d059ceba42df151adf9fb55222fc0a4aa53be9848d44a4c9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2705f53edde93b5fcd560143edd08d8906ce41f152c26a31de1df8e9d5cce96b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "542df18211d3da795ba9e2c3f3016aa9b58444b59c7cf78ad78e618f90167449"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e969a6f223edc6578f04fd95a6279146bd63b765414e5c0252ef16bc7d3ade7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c609924051e7358406a9800c45b6242938801029b29667955a98d89390c4b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "e094c1f20b16d6d70836b64f1faf58185316238ae312473584d98f2a655005a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef12880c662a2751cbe59a432d9d909682938007563e8f21b64142fa54bc2fc"
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