class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https:www.scaleway.comencli"
  url "https:github.comscalewayscaleway-cliarchiverefstagsv2.37.0.tar.gz"
  sha256 "08a2bc5e4c70218801ee20959b889a5bde0db0c97096f38848bd3618dd46edda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e633dee7e5240fba18460e0ccbf1a0dce2caf12d0c8521e39bde3f07d21272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e633dee7e5240fba18460e0ccbf1a0dce2caf12d0c8521e39bde3f07d21272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45e633dee7e5240fba18460e0ccbf1a0dce2caf12d0c8521e39bde3f07d21272"
    sha256 cellar: :any_skip_relocation, sonoma:        "6608cf8e7aa334472c5b0af6d459ec6ea5a57cf86efb1dba54e7eee0f434140b"
    sha256 cellar: :any_skip_relocation, ventura:       "6608cf8e7aa334472c5b0af6d459ec6ea5a57cf86efb1dba54e7eee0f434140b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d049d5409e0d6413e13ab0579067c30de0f0ba16ae8180a33be9f9b6cab98601"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdscw"

    generate_completions_from_executable(bin"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath"config.yaml").write ""
    output = shell_output(bin"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath"config.yaml")
  end
end