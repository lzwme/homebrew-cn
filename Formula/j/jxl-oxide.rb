class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://ghfast.top/https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.3.tar.gz"
  sha256 "332a716446daa5bb5571b43e9aea00df96378517709b9ef68b8230a16d04deef"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9dfc3d51f58ccfbc27fd108f7d9004a3c36662ddb747d3758ea0be7f6f12b6df"
    sha256 cellar: :any,                 arm64_sonoma:  "cd5ffd5bacd16c9de2ce8f02f9173aebf5a4a51a9df5b6fe8475eb62910f8275"
    sha256 cellar: :any,                 arm64_ventura: "2ee31c523e2856cd0a32f2cffd238f5a18fc5cce2781b5bc6d554abdead6f4bf"
    sha256 cellar: :any,                 sonoma:        "b39b4d67a5e8d9208d8a80d2c4d7ee474dd81ad0ea6a6d565d6bd713fa6d7fd8"
    sha256 cellar: :any,                 ventura:       "61d5aeb5dc501c383dc401b933bdf9287e72632d3fa0e8fa96c95a27d012470b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c5db11aa4a993932a3fa4a56427806de870d15a48ad1f1e9edcebb09b118ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07e2dc9301710154fc0ac2b698ca6a48d50c8447032d08c4b5888c2935f3925"
  end

  depends_on "rust" => :build
  depends_on "little-cms2"

  def install
    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/jxl-oxide-cli")
  end

  test do
    resource "sunset-logo-jxl" do
      url "https://github.com/libjxl/conformance/blob/5399ecf01e50ec5230912aa2df82286dc1c379c9/testcases/sunset_logo/input.jxl?raw=true"
      sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
    end

    resource("sunset-logo-jxl").stage do
      system bin/"jxl-oxide", "input.jxl", "-o", testpath/"out.png"
    end
    assert_path_exists testpath/"out.png"
  end
end