class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https:github.commfontaninipresenterm"
  url "https:github.commfontaninipresentermarchiverefstagsv0.3.0.tar.gz"
  sha256 "f239e5f2f6cbd5b16d5170e78ff773b8164e433a8260f4187faa5670dbbd521f"
  license "BSD-2-Clause"
  head "https:github.commfontaninipresenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c19860dea2e66a0a661fe1c8dd16944cd7418f82540bcdede7a49a7ac5a93292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f24d85797025698c233a28d5dc4106f3a385d85423cd27038fee96df1fea939c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f8489f9fe5c5d27c25548ff2a704d9a9af31e3ac32a81016892885064820cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "385812f1203226b5d65617672241708e251a47e8cb0786ff6273eff0171a630b"
    sha256 cellar: :any_skip_relocation, ventura:        "4b44118f836f7bce292f99b131f149773f7d144fcffa476e740222ffab2aa555"
    sha256 cellar: :any_skip_relocation, monterey:       "83dbcb28899b966cc95e56688a958ae6c9f6f5de1ec64b880107f3a149f8f9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b94d13ab0d5e706e814968296e65b61d69ed36a5d6ca726a7e3f2ac036b49811"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}presenterm non_exist.md 2>&1", 1)
    assert_match "reading presentation: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}presenterm --version")
  end
end