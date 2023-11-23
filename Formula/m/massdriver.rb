class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.12.tar.gz"
  sha256 "7f40d714b1c2ed1d189d1ae249e80422eedff205d0f96b20ac5d6565c601a805"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ddcca8c1af3aa8ad3a981e74836e6a20f1c99ba5805bafbb4b94e1ec5eb013"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7ef321c35ee3d5b6a37163d647857e057a3bca85e3fdcb9a5f412cc8469613d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a131320c5ef7d711f45be808b767c68df52f631af0bd6d57c92e0215aee7773"
    sha256 cellar: :any_skip_relocation, sonoma:         "a725e078e5e01cef11f1e3c42e371e459989de92c65a16689c769610288184a9"
    sha256 cellar: :any_skip_relocation, ventura:        "403c30e03ccd5eaef64afdd3c3a836d77fd295beb97157df748b005a4c775c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "19b982d8d71425608a809ba88144d4aed869bf6805f1100e222287adcd7e21f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4121766960709c41fe66299f4ab8539a4d6fa9c2393454de0520333adca434f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end