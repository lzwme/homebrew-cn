class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.38.tar.gz"
  sha256 "8f792c06f680f5f609ef1bcd073854b813cda223d129d690b300d96ed8cc829e"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ff10c70ad741e048cfc1f9a414035c500e9217573b70cb3b3ae7edb0e1f0e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f07e55d408480f832a85ecc11d365784d1db6e1342a306c9c75078bd5c05e73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a1e36d54e67807f29a9f24973737f2fd402a50627fea77a6f777005eddeab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8270db07d04fdfabe10c1f0772bd35ee416c214b2795b483e73ad9c6119a63de"
    sha256 cellar: :any_skip_relocation, ventura:       "3b3bd5c16e5dcbad3770e79d2c24d2b432e198e9f07f29615da58901efcbb456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d40dc682a9a58da7f367309eaa4b93ea448c4f1d8cd28c9881ccb3f956c86c"
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