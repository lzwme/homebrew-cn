class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.7.4.tar.gz"
  sha256 "8e3da890d0b05ab65532627faf180aed43e19ff835bdce75aced04362bb4de13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eef9f15588166eed7db1fc80d089e512ffa49aaab34e2628fe901d388fa5171"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eef9f15588166eed7db1fc80d089e512ffa49aaab34e2628fe901d388fa5171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eef9f15588166eed7db1fc80d089e512ffa49aaab34e2628fe901d388fa5171"
    sha256 cellar: :any_skip_relocation, sonoma:         "f23b04e216ec3fee8745b4afab26b42ff492be0ee602a4d02e8dc2a5de4bc0e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f23b04e216ec3fee8745b4afab26b42ff492be0ee602a4d02e8dc2a5de4bc0e1"
    sha256 cellar: :any_skip_relocation, monterey:       "f23b04e216ec3fee8745b4afab26b42ff492be0ee602a4d02e8dc2a5de4bc0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d6f195b78939712771b667f2f95c6073d476f774a1c59c5a66ca446e4e6c0c"
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