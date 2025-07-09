class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://ghfast.top/https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "a94d221a7eef439b6b174cba6f84a1f945cf4c292caa7ed7577655cc8c7514cf"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d977939ec4f250b8a8e5fff098899fc307edcfdfca7c50ee7adb73d0933f1e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d977939ec4f250b8a8e5fff098899fc307edcfdfca7c50ee7adb73d0933f1e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d977939ec4f250b8a8e5fff098899fc307edcfdfca7c50ee7adb73d0933f1e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5afe5e0c7a959dfb7ff049be6aa1bbca757345ff96840ba3dfbcdfaf25d8b539"
    sha256 cellar: :any_skip_relocation, ventura:       "5afe5e0c7a959dfb7ff049be6aa1bbca757345ff96840ba3dfbcdfaf25d8b539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49977091873ecab93eb0ac468eff66b45e62f9b48b6eefed3315462264f39cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "internal/hclsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    assert_empty shell_output("#{bin}/tfsort invalid.tf 2>&1")

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end