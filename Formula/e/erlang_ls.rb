class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https:erlang-ls.github.io"
  url "https:github.comerlang-lserlang_lsarchiverefstags0.54.0.tar.gz"
  sha256 "bdc2dcb4ec47e4ca06f69bb87947c4b8ef0251ec0ee286c839685e9b3a66bdd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b806b747ad82132515c7daac0148eae43e3f8e662bc9823460aa2d1c87e047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed48a99645da60e306ed92fde0cd0e8d97f299a155538fcf1a525bd94664cfea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "914459e9c187f882660325d53d4df3851cb0fd62c52e68ce32d1bbd9de99be0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c081cca18f5827b93b778b5f7f8317ec3c098e687a9fafb9156e499aa3f164c9"
    sha256 cellar: :any_skip_relocation, ventura:       "27da19ac3697115a5e6d0cf1a39999df1b4a5c2a5e64285404b04c2aae123ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf51c1c798ad6f0e6ba9cd811d89d4ea61f862c55243f5e35129bb8948f9d1f"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output(bin"erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end