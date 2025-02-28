class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https:www.openshift.com"
  url "https:github.comopenshift-onlineocm-cliarchiverefstagsv1.0.4.tar.gz"
  sha256 "c059de99575ed896d5cb5cd687d5bc820dc370d69b05c89466cded186371f5c3"
  license "Apache-2.0"
  head "https:github.comopenshift-onlineocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8c44aa5eee197d33672536c986c977f3a3132361a54bb00082392cee3871aa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a99a062aa564ffcf9328568cc21775fd1f9501c6fac51667da779e94cfc18c67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "697fadc6ccba431b2c8f708186bbd802ece5ad268dd935155ef81aba53064302"
    sha256 cellar: :any_skip_relocation, sonoma:        "72232f540ef373d344e963676219f63140fa934b991857744e515eaabecc3197"
    sha256 cellar: :any_skip_relocation, ventura:       "5c466e50ff2fb5815d1a80847f3bed4e8539464814ad7bed56f50b04eb8a5775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f64198c68b06d8d8529394bce2eeb36f8cd2c73fda4b6a70964a634a2f0d0c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), ".cmdocm"
    generate_completions_from_executable(bin"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath"ocm.json"
    system bin"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end