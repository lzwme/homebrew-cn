class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https:github.comscalewayscaleway-cli"
  url "https:github.comscalewayscaleway-cliarchiverefstagsv2.33.0.tar.gz"
  sha256 "cacf2f6bd749d14aae0ac2168197c3fd763b0e94d630fd07007c50bdce96a068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "831c35c560df566b67594c496f92e949ad0036ba2520821a463415fdcca71dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "831c35c560df566b67594c496f92e949ad0036ba2520821a463415fdcca71dcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "831c35c560df566b67594c496f92e949ad0036ba2520821a463415fdcca71dcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b43561ca899bfcfbef9647003b92ece27f51367533ee9b9885d5a075d4cc4f1"
    sha256 cellar: :any_skip_relocation, ventura:        "1b43561ca899bfcfbef9647003b92ece27f51367533ee9b9885d5a075d4cc4f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1b43561ca899bfcfbef9647003b92ece27f51367533ee9b9885d5a075d4cc4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c170383110a5bf7b98aa03f594bdd847580c1177b653b64cc15cff62abd7bd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), ".cmdscw"

    generate_completions_from_executable(bin"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath"config.yaml").write ""
    output = shell_output(bin"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath"config.yaml")
  end
end