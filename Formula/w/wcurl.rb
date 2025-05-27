class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https:github.comcurlwcurl"
  url "https:github.comcurlwcurlarchiverefstagsv2025.05.26.tar.gz"
  sha256 "a745475f3511090685c4d000a10f4155147b75a8c7781764612a7e8f67bb6d82"
  license "curl"
  head "https:github.comcurlwcurl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5bb7863101c3381fe17a41e0c4745bd2071ed7e235630b4308b397cf6b78bbe2"
  end

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin"wcurl --version")

    system bin"wcurl", "https:github.comcurlwcurlblobmainwcurl.md"
    assert_path_exists testpath"wcurl.md"
  end
end