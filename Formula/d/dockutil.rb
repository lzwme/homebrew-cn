class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https:github.comkcrawforddockutil"
  url "https:github.comkcrawforddockutilarchiverefstags3.1.1.tar.gz"
  sha256 "ccea7c5d49c1ee5b1da1371f5592f4672ba748c32216cd9c87cfbf756a1979c7"
  license "Apache-2.0"
  head "https:github.comkcrawforddockutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd5145bfba4c5e8c95d7a31255a186daf191200689f55e38cf24bf566e153a0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82853b3be415369f6bc19d7ec61f3e72711e870270a997db58e57e33b7339b0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7767fb0225f289867b7da17d049ae6763e635d2c3caaaaece0f61f9bb108f545"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de2072f5f81ae6324fe9ad626722d437249214b6a8fa032bf4bec9164e21905"
    sha256 cellar: :any_skip_relocation, ventura:        "d6778f0cc7a2d4c98f78a22cacec7f92edfb5596736b59bd63226f508f5ff728"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf9723fb6e9f4ed2cb780aec059f791d7b36c7e9f38e78c9f9b80829dcf3bcc"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleasedockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockutil --version")
  end
end