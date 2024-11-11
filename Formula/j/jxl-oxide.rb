class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https:github.comtirr-cjxl-oxide"
  url "https:github.comtirr-cjxl-oxidearchiverefstags0.10.1.tar.gz"
  sha256 "20945315b9e5b30b7685d8329a4049c66967461afdc0ff8ea7cc2c5a15156f29"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c95cb4ce1e2459e01c37f5c172e3e98a178db609504a570ea05b37effb477c1"
    sha256 cellar: :any,                 arm64_sonoma:  "b2b66a6e61f7a3598e9f409dcb00b9c69ceacfb15cdfb8cfd8fcba876506b5a7"
    sha256 cellar: :any,                 arm64_ventura: "24d584dd6d99d309f3fc5da8ce82c2aefa8efcb093649d34633557e8526dc792"
    sha256 cellar: :any,                 sonoma:        "45e82b9e1d92eae7a7c3d1e60c22c0794d8bb10cd5e78d278127cd2773a37a24"
    sha256 cellar: :any,                 ventura:       "fb525cdf14920ce2d5e9c1a84af71e051e934e410a040e1a0915799988188778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c5f3b6bc0836b2581a50760699fa94bb6f6d11f18322b865ba02e3b36723dd"
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