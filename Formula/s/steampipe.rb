class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv0.23.3.tar.gz"
  sha256 "0cd76eac829aa3a679e10e4d56260e85929d3582220b3b2530b99317c283f5d3"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84ce33678a0deb412a6282e153607335b12ee687cbe93c71a5b54d67911f077"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad284b930871dfc1f19d95dee06c25439b6d43486571115f318df3677f855a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfaafc2fd0b8822638ddade78996225158ee3e22dc3062938b79ea3b046f0e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fe5c2e5be36d22b3a3891e0fba44e123debf193a6b679ed14d9d3f01bde910a"
    sha256 cellar: :any_skip_relocation, ventura:        "1d7ada1a01d681cce9b291178201ffd6a444f28da97911e5ddb78f728d224bef"
    sha256 cellar: :any_skip_relocation, monterey:       "8da41afb6ac77eefbb11ce6263652e6ce79e842299ea678c288d932c96d68dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fef0fd4994640abfc32306dfa81903b6c7c4d7cb2e78846a752a774a5f3e94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end