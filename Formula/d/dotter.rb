class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https:github.comSuperCuberdotter"
  url "https:github.comSuperCuberdotterarchiverefstagsv0.13.2.tar.gz"
  sha256 "a62f2d55e48e5e9a84417960e8bdf0f2a9c3ce730dfd759e0f927055feb12e35"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d86971116fbbb6265f3f4e6b069e027f2baf4d0fc2511e3ce22163001d169a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "782718cbaa1584005e7d81f2be3db680ca20993ca41f9ab794180a460a85e5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3460c0adc3d539180a80363587fc9bf228f7da4a93863be9987bd2142bec92ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "e895cb3879073dd130383e5a53b89eab81035f49cfa0b157d452d6255ee8f5a7"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf3a8d51ed21e82b9ba4b3e5fa5b31ab2675bc9a2f79533569c6f141df7f403"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0bd0316969c5121187063557e6804e41e1d21832b559b3aa68537599592fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e24490c5fb2ec8d638abd76340dc2f81d6c50b0324b29c08eeafa16ab62f52f8"
  end

  depends_on "rust" => :build

  # patch time crate to fix build with rust 1.80 and above, remove in next release
  patch do
    url "https:github.comSuperCuberdottercommitd5199df24e6db039c460fa37fe3279f89c3bfc63.patch?full_index=1"
    sha256 "757e0368cb7668efedb2bab21dec67850ead3f4951a5717c9bffef8a5da75bea"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"dotter", "gen-completions", "-s")
  end

  test do
    (testpath"xxx.conf").write("12345678")
    (testpath".dotterlocal.toml").write <<~EOS
      packages = ["xxx"]
    EOS
    (testpath".dotterglobal.toml").write <<~EOS
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    EOS

    system bin"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end