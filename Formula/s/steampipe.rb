class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv0.23.1.tar.gz"
  sha256 "b8c05079517d23b228bf51522fbf3862c659c501ff09343e43a50ed169c06cfc"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e85f500a6003af2a5bb55e4ee0021f757836d40507db910bd2a09ac2121fae33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbec3a39340c71123bd644ffc1294fbdc956160392048813d90ba985405e08ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "033de3a17ee607a9cbda921381a8504655b559a6a8ab733c0f3733d17ee1d456"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44c6a4edf52a6ff0a1aa90bdac32a24c8e3a42b984ae46742f82535544f2657"
    sha256 cellar: :any_skip_relocation, ventura:        "77eb73206c9fa7a0e29ce7a33fc09695f9b75ac23293b6392859c59dbfc63130"
    sha256 cellar: :any_skip_relocation, monterey:       "85f4e86b7e21d882fb180d3cd95e1fbcd649e3ca32d3bb7cecba1911dd003d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b4d06956b5785f07961bda176353c6e05e8de23684c6696aa9122c74ae5bae"
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