class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "3dd76d306d7bde6183145981893dd0418735271f20b92d9e584d34917e37eaf0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c02fd76764896749f1fbd8421e92c41e89aa15ed9f853735a843930d7aefd28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05fca502fd56eba509bd70d1e4865295bce3cc2cac3585b88a1b3c13323672af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ed3db239d8110aa3087ffca175d8cac38fe967921f34345388fd434195be47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe6a2a0541f4c142c0b4fa7258c56831f9f0edfbac368555d9303c0c357f98c"
    sha256 cellar: :any,                 arm64_linux:   "36003e001bbc677f8af91ec269815b54996dc3be9620ecf4b127e97b995aa9a8"
    sha256 cellar: :any,                 x86_64_linux:  "c53df1dc30e35e868a1f8b1acc4e79f8b05f12d62ec9de8e9fa33e3315bbaf0c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    (testpath/"concord").mkpath

    (testpath/"concord/config.toml").write <<~TOML
      [display]
      show_avatars = false

      [voice]
      self_mute = true
    TOML

    (testpath/"concord/keymap.toml").write <<~TOML
      [keymap]
      leader = "space"
      StartComposer = "i"
    TOML

    assert_match "concord config OK", shell_output("#{bin}/concord --check-config")
  end
end