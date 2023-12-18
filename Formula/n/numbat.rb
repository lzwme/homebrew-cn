class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https:github.comsharkdpnumbat"
  url "https:github.comsharkdpnumbatarchiverefstagsv1.8.0.tar.gz"
  sha256 "b02e4227ba1e7234c246099365143e01b957dfe5ce530424912b485ca42d28f9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsharkdpnumbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd8ad3b664a1a98d472a4ad59ff2db2bff4ba8dca4fadd0792a27cc5efbf4f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab7dab83cb291585659b1615d9ef4cbef07add75dc106433b6647489f8ca314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4032341a613ab8e89ee68f71ad2006279308e4f5a66aec09199aaaea966c5d9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "926c306f92d43654bd8e577faa5d1e48dad271c040849f3903157096956d3814"
    sha256 cellar: :any_skip_relocation, ventura:        "cb303aefe51de3d497bcbad5d2c18ed925bf3c1b13e22b5ce16c81706e4cfdbf"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c3f28dd050fd27162a9abdc2ec9fb1c5482b03c6dcfc35c4ca9a48ae52171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ae35c6f3ce28288045f047317d462384be6e17c30e504fc29c0cb2c5c1db80"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbatmodules"
  end

  test do
    (testpath"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end