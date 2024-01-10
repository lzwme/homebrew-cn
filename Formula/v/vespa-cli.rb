class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.283.46.tar.gz"
  sha256 "d9c162f8ee5d5fe19786d07b91e40a885a63d0e2fa2c896ea3bf8eab570b54aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f79f1308e856acee60ea7989fa0807be92d5d5e76347df24197c6a7005b1469"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c96e4e66308e191d7f8fa86758ca24508c58a5f7c8ea5872abea4ee455db5bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e642f347deb843f7ff01816ba9521d5c15948e4673586d537ec2ca79640fdc6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cb28b90814b68d6823591e347279a9156a31f01adcede1ecad3cb749df9fd31"
    sha256 cellar: :any_skip_relocation, ventura:        "016c863103573a403414c2f408ba700fafe0eba5c3c5328c2d41a6a830b274e9"
    sha256 cellar: :any_skip_relocation, monterey:       "23688309fd397491493be93f586ddc681704c0a5afd1370958fae6d1f3bc8f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fdc5bd41723d87b76051d3543798a8d79ef39ddf3da2cd0098951bb1e22cc2"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end