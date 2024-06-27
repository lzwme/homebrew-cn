class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.7.2.tar.gz"
  sha256 "3754d0932c0bb1cb59d1007ca77f7136e10dc2be13c922317604b07632db9941"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30527dbf65b613b3f0c768b172ee7a8548998a10c6fb21ad66893cc9f3ee553f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c0178c4bf4e4d4b52d8c46ce6d7164eab40f001b1da0e669589c4bc6600861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f73a04a481bad967b04911d11fc4f11c3d26782eda035dbd467f8c4300e1e52"
    sha256 cellar: :any_skip_relocation, sonoma:         "9db34cc209612b59eac6cfbea345d815753d0a1f5f405400eb044b1bb5d5139d"
    sha256 cellar: :any_skip_relocation, ventura:        "585c51e99e4abd052c2f4a2eb120458228efaa79b7f7c83fc8d817042ff661cf"
    sha256 cellar: :any_skip_relocation, monterey:       "a94497f3582fb570ea002fc5279f1934f1d16f1df64365cfda5787e48a0209ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3236a658e051f443326776df19d039564a63858be8f9d3e8939dea0506a8627"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: io timeout", output

    assert_match version.to_s, shell_output("#{bin}godap version")
  end
end