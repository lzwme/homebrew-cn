class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https:github.comtirr-cjxl-oxide"
  url "https:github.comtirr-cjxl-oxidearchiverefstags0.12.1.tar.gz"
  sha256 "3890560466a54d9cfeb76f9b881abb7666f9ae72be74fcd7c38b8d58f36d1212"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b188404b4c48300b956a953cb97f1692f445c05d02ea4555f773e940154d0f40"
    sha256 cellar: :any,                 arm64_sonoma:  "58a03c09bec35c08d488bd283d3dcc6f6e2567354089c106653019db717f655f"
    sha256 cellar: :any,                 arm64_ventura: "cea0e98577bbdffa68cf3cdf2d39f28829f0b51c8652463c46e89b6a48fcc69d"
    sha256 cellar: :any,                 sonoma:        "b14d65394d38fabe23d9f156cab070ffc63df25eebb4c5af34314866ae1ce39d"
    sha256 cellar: :any,                 ventura:       "258b1dce5745ac33ef2b8e475ce278d929bdeddff8a5dc55c006eea31a8385e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13463c6085217ae5fb756f9689f2a06339a40f2974349ccafdf336aa0b532e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810e036adb1d2a6c6e1c72b5144c304521aab51a229da36c0ed3e115d0748f39"
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
    assert_path_exists testpath"out.png"
  end
end