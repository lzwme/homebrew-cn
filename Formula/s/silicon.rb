class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https:github.comAloxafsilicon"
  url "https:github.comAloxafsiliconarchiverefstagsv0.5.2.tar.gz"
  sha256 "815d41775dd9cd399650addf8056f803f3f57e68438e8b38445ee727a56b4b2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "3cad4ec20ab16b1a2d1040416723bae123955facbe599350fb9bb81f716aecb7"
    sha256 cellar: :any,                 arm64_sonoma:   "8b022877b17b6066bc489492515fe08152bacca5328f2432820fd044050fe416"
    sha256 cellar: :any,                 arm64_ventura:  "5efeb8cbcdd20ef78104a7e7193f5da0426c661fa173a5efe7682e72e856b014"
    sha256 cellar: :any,                 arm64_monterey: "71bcf12d642e3902b8be7f0ea4b553e6e088756dbb40d381f744b10b845bc0da"
    sha256 cellar: :any,                 sonoma:         "20ee4179a8d037ad0ce0feae5643e20b2bf6f67718253a3f0022fb5fb701e8e0"
    sha256 cellar: :any,                 ventura:        "bf3cfafcd40201eae34dd09491b39a35de15006ec165f7ed82a126dc175f96c9"
    sha256 cellar: :any,                 monterey:       "8b51904d6783f059bd75861408e70131e4f8798ce2bd8158d706676a0170e27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a94bbc93480f99ed069fec1e7f86dee27922e2b0c1d00ba8f6a6c79f42da3f5"
  end

  depends_on "rust" => :build
  depends_on "harfbuzz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
    depends_on "xclip"
  end

  # rust 1.80 build patch, upstream pr ref, https:github.comAloxafsiliconpull253
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.rs").write <<~EOF
      fn factorial(n: u64) -> u64 {
          match n {
              0 => 1,
              _ => n * factorial(n - 1),
          }
      }

      fn main() {
          println!("10! = {}", factorial(10));
      }
    EOF

    system bin"silicon", "-o", "output.png", "test.rs"
    assert_predicate testpath"output.png", :exist?
    expected_size = [894, 630]
    assert_equal expected_size, File.read("output.png")[0x10..0x18].unpack("NN")
  end
end

__END__
diff --git aCargo.lock bCargo.lock
index 0133214..a02f140 100644
--- aCargo.lock
+++ bCargo.lock
@@ -823,6 +823,12 @@ dependencies = [
  "num-traits",
 ]

+[[package]]
+name = "num-conv"
+version = "0.1.0"
+source = "registry+https:github.comrust-langcrates.io-index"
+checksum = "51d515d32fb182ee37cda2ccdcb92950d6a3c2893aa280e540671c2cd0f3b1d9"
+
 [[package]]
 name = "num-integer"
 version = "0.1.45"
@@ -1474,12 +1480,13 @@ dependencies = [

 [[package]]
 name = "time"
-version = "0.3.30"
+version = "0.3.36"
 source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "c4a34ab300f2dee6e562c10a046fc05e358b29f9bf92277f30c3c8d82275f6f5"
+checksum = "5dfd88e563464686c916c7e46e623e520ddc6d79fa6641390f2e3fa86e83e885"
 dependencies = [
  "deranged",
  "itoa",
+ "num-conv",
  "powerfmt",
  "serde",
  "time-core",
@@ -1494,10 +1501,11 @@ checksum = "ef927ca75afb808a4d64dd374f00a2adf8d0fcff8e7b184af886c3c87ec4a3f3"

 [[package]]
 name = "time-macros"
-version = "0.2.15"
+version = "0.2.18"
 source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "4ad70d68dba9e1f8aceda7aa6711965dfec1cac869f311a51bd08b3a2ccbce20"
+checksum = "3f252a68540fde3a3877aeea552b832b40ab9a69e318efd078774a01ddee1ccf"
 dependencies = [
+ "num-conv",
  "time-core",
 ]