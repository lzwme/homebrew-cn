class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https:github.comtirr-cjxl-oxide"
  url "https:github.comtirr-cjxl-oxidearchiverefstags0.11.2.tar.gz"
  sha256 "60d327942030f54190c7d2650edf0804349baa20c2e7a21ed4cb8950e3f4e904"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ee77d9a48a6a5cd448859f7658d12bdbb3602e893aedf6f9aae00be59426eed"
    sha256 cellar: :any,                 arm64_sonoma:  "a3add0ade186427fe4d21eebfa883593a774bda96d39c287dfd7378efc8d992b"
    sha256 cellar: :any,                 arm64_ventura: "ff0cc669ee1b084ef04b83406a4cf4bcd1b0c43d9b3f17a3b641f35203637ed3"
    sha256 cellar: :any,                 sonoma:        "18a35d11ffb88f9f6e63d155579dd059d279b7fcec6eb6d46ea2d5d777750aef"
    sha256 cellar: :any,                 ventura:       "92cae5da5ad47e6d1e697e4efeb0d1950a8f962e739a7b4410ce2e8ed2b96741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f1e81b550c44862880f3bb9dffd84026defbc8f11e34ed937006a70a585bee"
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