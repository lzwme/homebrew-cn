class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https:github.comtirr-cjxl-oxide"
  url "https:github.comtirr-cjxl-oxidearchiverefstags0.10.0.tar.gz"
  sha256 "b5e0efdcad45c4f1b5982dc9f6e27aa890cb5c9d71636710854bc551ed75ba81"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf44e9880c3f3db52703670d579b4dc4404f0829d5ba55e5674c2ba928b04b2b"
    sha256 cellar: :any,                 arm64_sonoma:  "75e942d745e4f87c91137219fd3f9a4fe4e46f140cdab2f667ab9bf10cd801e4"
    sha256 cellar: :any,                 arm64_ventura: "91fd49a8ab31355d49e209b8f498d27caba1456476b215250681ebba81390acd"
    sha256 cellar: :any,                 sonoma:        "d1346c2fbe39cb0f54243e5a5f7facc61f7631ffda74fa747b605c3708c426cf"
    sha256 cellar: :any,                 ventura:       "6e83a034b5ec31bbf2c728091c80e7a89cafcf99350e66c4a05a02ae54738734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6535eb01800a5b7d34bd94ea8efb27c9250f9a5a3f48f1ce6d2953efa135a023"
  end

  depends_on "rust" => :build
  depends_on "little-cms2"

  def install
    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "cratesjxl-oxide-cli")
  end

  test do
    resource "sunset-logo-jxl" do
      url "https:github.comlibjxlconformanceblob5399ecf01e50ec5230912aa2df82286dc1c379c9testcasessunset_logoinput.jxl?raw=true"
      sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
    end

    resource("sunset-logo-jxl").stage do
      system bin"jxl-oxide", "input.jxl", "-o", testpath"out.png"
    end
    assert_predicate testpath"out.png", :exist?
  end
end