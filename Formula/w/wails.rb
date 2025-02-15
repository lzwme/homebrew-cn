class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https:wails.io"
  url "https:github.comwailsappwailsarchiverefstagsv2.10.tar.gz"
  sha256 "fb167f939af39496f2aa193406d66913aa811ac593668d3725b90c933d5da29a"
  license "MIT"
  head "https:github.comwailsappwails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f37c08f4eedd52fcc8388822488aa3936b24638e0eaa28d1cb13ec24ca2f563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f37c08f4eedd52fcc8388822488aa3936b24638e0eaa28d1cb13ec24ca2f563"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f37c08f4eedd52fcc8388822488aa3936b24638e0eaa28d1cb13ec24ca2f563"
    sha256 cellar: :any_skip_relocation, sonoma:        "7890d919d9491bf947a8dc0ca6da2266a850cc8815ab51f9519f88f84a825588"
    sha256 cellar: :any_skip_relocation, ventura:       "7890d919d9491bf947a8dc0ca6da2266a850cc8815ab51f9519f88f84a825588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61512a7494d2124bd65cc65531e65bbfd19cf5bc5ff5bc8956c4b97b034a115"
  end

  depends_on "go"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdwails"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}wails init -n brewtest 2>&1")
    assert_match "# Initialising Project 'brewtest'", output
    assert_match "Template          | Vanilla + Vite", output

    assert_path_exists testpath"brewtestgo.mod"
    assert_equal "brewtest", JSON.parse((testpath"brewtestwails.json").read)["name"]

    assert_match version.to_s, shell_output("#{bin}wails version")
  end
end