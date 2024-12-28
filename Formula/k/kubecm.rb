class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https:kubecm.cloud"
  url "https:github.comsunny0826kubecmarchiverefstagsv0.32.1.tar.gz"
  sha256 "30fd9c306b0820be24f56ebc1319a956eb1c05afeee63ae4ab5779e5fc897692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225f10417ff1e8833e567eca54e30b5b4ad5e45ff59149f99e53b2c074d0f420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225f10417ff1e8833e567eca54e30b5b4ad5e45ff59149f99e53b2c074d0f420"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "225f10417ff1e8833e567eca54e30b5b4ad5e45ff59149f99e53b2c074d0f420"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7d521861c8d136d95d9cd9a3698812d7776a1644759a33a42c02710dced62b"
    sha256 cellar: :any_skip_relocation, ventura:       "1d7d521861c8d136d95d9cd9a3698812d7776a1644759a33a42c02710dced62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cff271aa2e4ac6f95fe3722ee176cca481a6bdaf959e4a9dd9025da9bc49b9a"
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