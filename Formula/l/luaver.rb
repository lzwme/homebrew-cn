class Luaver < Formula
  desc "Manage and switch between versions of Lua, LuaJIT, and Luarocks"
  homepage "https:github.comDhavalKapilluaver"
  url "https:github.comDhavalKapilluaverarchiverefstagsv1.1.0.tar.gz"
  sha256 "441b1b72818889593d15a035807c95321118ac34270da49cf8d5d64f5f2e486d"
  license "MIT"
  head "https:github.comDhavalKapilluaver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "423d7c791335f69639c53e2eb5ccbfd0120deeb61984a2744a72d0ab635317af"
  end

  depends_on "wget"

  def install
    bin.install "luaver"
  end

  def caveats
    <<~EOS
      Add the following at the end of the correct file yourself:
        if which luaver > devnull; then . `which luaver`; fi
    EOS
  end

  test do
    lua_versions = %w[5.3.3 5.2.4 5.1.5]
    lua_versions.each do |v|
      ENV.deparallelize { system "bash", "-c", ". #{bin}luaver install #{v} < devnull" }
      system "bash", "-c", ". #{bin}luaver use #{v} && lua -v"
    end
  end
end