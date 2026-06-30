class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://ghfast.top/https://github.com/dropbox/dbxcli/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "04e9dc214c481a0cdbf39deaadf6ec247188c9c207b3c440cb6b139a17020e80"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9bf542b559e2509e748cf8d3001400e1ea083ebbe66117634616ed909bc2ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9bf542b559e2509e748cf8d3001400e1ea083ebbe66117634616ed909bc2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9bf542b559e2509e748cf8d3001400e1ea083ebbe66117634616ed909bc2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e615d67733461d4c55a4e50eb97f9b754a3199f68141ed6794a9f18dac23d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd45b68500e20397644d356a67d14c5ecbfd23d4a544779a36e8dab77d2fe0b"
    sha256 cellar: :any,                 x86_64_linux:  "414dda04ef96b58ba5868e8155d6ac6a1f8918fbe791148b2b976d20def445ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end