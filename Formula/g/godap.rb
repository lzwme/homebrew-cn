class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.9.0.tar.gz"
  sha256 "5463a81998659600737a71f60535e18d795f44aa995f92c9d57e854f6be92b4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19805a8ebb8898b1e9dd587714aea7978b42ccb48fbecf6bccb9c6e03ef1fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a19805a8ebb8898b1e9dd587714aea7978b42ccb48fbecf6bccb9c6e03ef1fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a19805a8ebb8898b1e9dd587714aea7978b42ccb48fbecf6bccb9c6e03ef1fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "56fee2cf80268e660612ee4bfaad512e65f187c980832b4d44748cfa33dbefcd"
    sha256 cellar: :any_skip_relocation, ventura:       "56fee2cf80268e660612ee4bfaad512e65f187c980832b4d44748cfa33dbefcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b890945d2b28c4157145937429d406d2d1ffa48bfa14feae51de830a697d050f"
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