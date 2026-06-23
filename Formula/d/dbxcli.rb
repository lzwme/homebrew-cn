class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://ghfast.top/https://github.com/dropbox/dbxcli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "6c80185757f2d80d11a83e03ee265c841f2e98244f92cf670da059ffbc7dd37b"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd8be25861752e0fc62016def85200135b87da70ba11247794c22b3d4e19400b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd8be25861752e0fc62016def85200135b87da70ba11247794c22b3d4e19400b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8be25861752e0fc62016def85200135b87da70ba11247794c22b3d4e19400b"
    sha256 cellar: :any_skip_relocation, sonoma:        "36553bbb5bc3d272a7d771ceb8c6598df948275a0cb3380fc4bc54f93d3a30d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9334d79576384212e95c98b7ba6931178be6f9af82cdabc45f55206c680f06"
    sha256 cellar: :any,                 x86_64_linux:  "f30db143662421a00b8e75d77f4ba7a615cdeb6689a9819844c99ba220ca1864"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 1)
    assert_match "no saved Dropbox credentials", output
  end
end