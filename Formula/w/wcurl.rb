class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https:github.comcurlwcurl"
  url "https:github.comcurlwcurlarchiverefstags2024.07.10.tar.gz"
  sha256 "962bb72e36e6f6cedbd21c8ca3af50e7dadd587a49d2482ab3226e76cf6dcc97"
  license "curl"
  head "https:github.comcurlwcurl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "af8adb8368a8844d3552b6b6efed89c10d4bb6b03220dab7bdc73b658422e04b"
  end

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin"wcurl --version")

    system bin"wcurl", "https:github.comcurlwcurlblobmainwcurl.1"
    assert_predicate testpath"wcurl.1", :exist?
  end
end