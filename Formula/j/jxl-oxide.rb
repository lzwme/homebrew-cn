class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https:github.comtirr-cjxl-oxide"
  url "https:github.comtirr-cjxl-oxidearchiverefstags0.10.2.tar.gz"
  sha256 "0a61b4de0df19f2aef4a9821f9ce74567dba86245450016c36baa7b40ba002c1"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc69ff3d50c7e7a7d7b75d956a71c41809929d22f4c4b4acc223143f5f3b5d2a"
    sha256 cellar: :any,                 arm64_sonoma:  "da900f9333d77a28dbb9c3b45b3e00bf2756b2e4628eb961fc94f11b2ee57982"
    sha256 cellar: :any,                 arm64_ventura: "41e145397bb7a512878d626f09d6965121fd9be0c622918b44ad93bb12753267"
    sha256 cellar: :any,                 sonoma:        "6e468bab7c9674647813a7328ae76a53d1c4a340bbaee9f8755cbc926d3a1487"
    sha256 cellar: :any,                 ventura:       "86826165fac92be29eb29f119a6e8ff4a1dfacfea5cce7dc7ecb4f03b36e92ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630ce91dfb03fb1e40630d30d4a20c948472467125a97a838f8c5b86530df675"
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