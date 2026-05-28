class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://ghfast.top/https://github.com/tanaikech/goodls/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "ddd8b8147ecd95e8aa4428b5bbb0d397878958736b331a4103a965364196b509"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa0792e8ce3cb67e3654424a59c56ef615ea25f1172477c6602e0ef66eed0c08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0792e8ce3cb67e3654424a59c56ef615ea25f1172477c6602e0ef66eed0c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa0792e8ce3cb67e3654424a59c56ef615ea25f1172477c6602e0ef66eed0c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a6a110eda04b125926d54a2097624cf853094e699cde5dbd10d9a5eed127718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41783435ba35dd65316d9e0eb9d6a34ba4315b6bc6cb8e31a40b0fc42050ef55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0628fe15d855a9872c996f51ca941ae0ed239572788ab34fc2bfefdf62014b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    expected = if OS.mac?
      "URL is wrong"
    else
      "no URL data"
    end
    assert_match expected, shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
  end
end