class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.6.6.tar.gz"
  sha256 "da9c864819d78f8caeea90d7056a27081055d39a48f80b24b4fc39c6538f4fa4"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "200646e78dbc89b13b30ee4f875f610d8af8bfbe5a8ae8b42828a83623a844c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afe724774f2b4ea381aca0103c3d0aec09554c34c44c1095487b62663d19ff64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "482adcbd612976cb82397fd94aa5a313a73ab45f9a36e056d3732ddbed1158dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "097bf9cf98e25e5b7d20cc4f967aa4ef3e1e8e52a8913df09dd2dc944397a677"
    sha256 cellar: :any_skip_relocation, ventura:        "59552aa43194320d6286e597c29d8d0abbda8e758b4c5c29ea000889b89f42eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d391e172083a6713234a4e5552bdf17c5c4893116919c77d468b723d5135ee96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b036e626bc499d71aec7b4c074fd0eb3c9b2d5d76a3783a70b8c3aa4947003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end