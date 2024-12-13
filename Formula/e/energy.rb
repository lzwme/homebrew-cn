class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https:energye.github.io"
  url "https:github.comenergyeenergyarchiverefstagsv2.5.0.tar.gz"
  sha256 "e1749e2354626d1ca4e22169752175807930d5fc1d48edcea4e890670fbac923"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd00e0905710425de05468f8b33550078362a72b25b0f0e421aecd745e640d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd00e0905710425de05468f8b33550078362a72b25b0f0e421aecd745e640d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fd00e0905710425de05468f8b33550078362a72b25b0f0e421aecd745e640d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "03fad90c4f03a8f883ccb4e09a70c6c1414cef3268d02dd86e0a175c4113fca8"
    sha256 cellar: :any_skip_relocation, ventura:       "03fad90c4f03a8f883ccb4e09a70c6c1414cef3268d02dd86e0a175c4113fca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b6a6b86a3848b20f4ce96c52ed044e23648e451e12edda2f8eac9ea730c035"
  end

  depends_on "go" => :build

  def install
    cd "cmdenergy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}energy cli -v")
    assert_match "Current", output
    assert_match "Latest", output
    output = shell_output("#{bin}energy env")
    assert_match "Get ENERGY Framework Development Environment", output
    assert_match "GOROOT", output
    assert_match "ENERGY_HOME", output
  end
end