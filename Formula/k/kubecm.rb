class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https:kubecm.cloud"
  url "https:github.comsunny0826kubecmarchiverefstagsv0.27.1.tar.gz"
  sha256 "901dc2759ab14fa5048a0cdd09301d3f8ff30870435c06ac07bc91ea0117804e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107bba7845e3e0cab4f3ea77f8c6b41d64d6f1dcf7f95af88857d1ea01314e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2f89518e05828de8e8ccffb2f4ef75ae40fae00bf02767f148142586455de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17df7272ae31bd1d21f1cc3ead23ab4a09263ed237a5793fd7517a5957266f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d842298966e851410a43fab34e34bc97b36167fdc28589fcc4530bd70d919a8"
    sha256 cellar: :any_skip_relocation, ventura:        "0173afa8860792be518f058a0a05e5144e936731f5562b185c6cecc8d3670d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "935f1bec395647758c9aceb1dd48eacaa100c1040f07c48648e4dc0b9d612a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b92f33eed76a4f16a5d3233caf198bbcd91c6a0afe57480837e6be835cee8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsunny0826kubecmversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}kubecm switch 2>&1", 1)
  end
end