class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://samueloph.dev/blog/announcing-wcurl-a-curl-wrapper-to-download-files/"
  url "https://salsa.debian.org/debian/wcurl/-/archive/2024-07-07/wcurl-2024-07-07.tar.gz"
  sha256 "5ee1d686aeef4353cb023be341f4b34401d8c6f55039cdda5d52d47cf8db4932"
  license "curl"
  head "https://salsa.debian.org/debian/wcurl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, ventura:        "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, monterey:       "5c65bb98d00279bedfb286a2fd324c139e4ddf20c97382418e86db25b2cefcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736e2648b6fcb39fea97a85c7eecfebd834e029421bf454e4d5f380785e8357d"
  end

  depends_on "curl"

  def install
    inreplace "wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}/curl\""
    bin.install "wcurl"
    man1.install "wcurl.1"
  end

  test do
    assert_match version.to_s, shell_output(bin/"wcurl --version")

    system bin/"wcurl", "https://salsa.debian.org/debian/wcurl/-/raw/main/wcurl.1"
    assert_predicate testpath/"wcurl.1", :exist?
  end
end