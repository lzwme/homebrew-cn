class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://ghfast.top/https://github.com/google/oauth2l/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "102c552c02109d440e27e6af9744e80d5d49981fbcf2ea7dcc76b6373b673095"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "994decb9cc5337738caebceb0e5549c2e5b662b775b400a92c8a810e0980850b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994decb9cc5337738caebceb0e5549c2e5b662b775b400a92c8a810e0980850b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994decb9cc5337738caebceb0e5549c2e5b662b775b400a92c8a810e0980850b"
    sha256 cellar: :any_skip_relocation, sonoma:        "88922eca9c444a4672b1f0c6164d95be28bf2387008f3123fa48dbf9c8899a04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e03b058a49e84e1477e696f9eff12ad10de2b591e35af3e52ee8ed07aa8f6e8"
    sha256 cellar: :any,                 x86_64_linux:  "e26ca5d3dcd98de0b8f82d871d64c3fa0825dfbbe5f52195b555afa0e89ea629"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Invalid Value", shell_output("#{bin}/oauth2l info abcd1234")
  end
end