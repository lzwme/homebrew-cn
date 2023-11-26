class Instaloader < Formula
  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/53/a0/49ded81d0134be2e1c22ae4706c35b74594ed1844bd1e9af703fd310d562/instaloader-4.10.1.tar.gz"
  sha256 "902cc8b9569ca7437323199c8e55dbdcd15ea5c8e874c7864e84a36dd55f8584"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3397cae68d8875961420423b85df908b8ab417beff7f44daefd177caa3809cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8e46ad0866532298e55c4a6123dd14fe29dc27025d6ce42bdc7549b5c09c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5f7859d3b213c86ae0503bfaf2f482f7dfbb3aeef9d10df30113ceaa1d1e28"
    sha256 cellar: :any_skip_relocation, sonoma:         "aadb1209d6e7299077935ca79b614c3aa1dee54bf61cef84ab6b9e705a8ba6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "47cf355bf2cc843d26bd7516596616e0628d34f1d7a0a4ce73a606fa28c44d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "7445ed46fa3bdc04fdc86d5f7daf50d94a4931da291dd2d3457c4ce5aea264e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d6747adb02f10ae40a6889e7d07d455bb1f1e9359dc56f7d0bb72e4dfb4e48d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end