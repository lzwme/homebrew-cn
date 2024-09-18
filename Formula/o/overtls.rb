class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.35.tar.gz"
  sha256 "01f709364606c86649457868b3ed7bc5970705e21921019a8437bcbd0e5e6733"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cb35d005c0fa57d4d4c93f8d48b63b87c641c1b6b720cb9dbdb56b708ae923f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd99cdf3e6d81edeb75cdca0ab09b7d53bc9ee643b3f52f686b3ac826ec3d2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4949aa144351be71ff49ada18336dc9ff60c3c2acb96042fead6857b549dc8e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ebcd53419b220e94c61972fff2b1ba56ce5ad91a34bafcaf6de3a06f999218e"
    sha256 cellar: :any_skip_relocation, ventura:       "bedad3e62190b4c091595f50e03934392461865eb1fa1b713097e7316f91f235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c0fdd40f273653b15cb4d34198f7c7853ef361464154227f283128ad32dcc0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls-bin -V")

    output = shell_output(bin"overtls-bin -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end