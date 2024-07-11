class Wcurl < Formula
  desc "Wrapper around curl to easily download files"
  homepage "https://samueloph.dev/blog/announcing-wcurl-a-curl-wrapper-to-download-files/"
  url "https://salsa.debian.org/debian/wcurl/-/archive/2024.07.10/wcurl-2024.07.10.tar.gz"
  sha256 "962bb72e36e6f6cedbd21c8ca3af50e7dadd587a49d2482ab3226e76cf6dcc97"
  license "curl"
  head "https://salsa.debian.org/debian/wcurl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, ventura:        "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c86c3062340c46b0f34fe4c17635d8a454524bf2f8fd86afc7efeb066686aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32103a14a42d6532c6a4b3d4558c3ebd0b07cffbfc761ef83e5300b38f18c23c"
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