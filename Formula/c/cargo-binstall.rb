class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.7.1.tar.gz"
  sha256 "594b1f0abdb02c588bbc9245ef7a922befb21228254f0c61742c0003abe9e843"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b2922f7f2ca8960b55a295009bde2ef6568caaf819ba99f3c51ee7e32e7093f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d911de273c0fbb1be68dc9db765a92e6cb1b98accbd53110ff22e5d575e8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2433f113c2c7614ec9d70d340b7ee083eb5a2da32a370c8223b7ac9c3c73349"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d379bc544d54758ec5ff8f904850890f3bd779a1e5c2f9e76b235f3fc7205a0"
    sha256 cellar: :any_skip_relocation, ventura:        "63d02dcad9619a3c8fed3bbee127d1eb44baece9eb33b2f884f0a87902f5c68b"
    sha256 cellar: :any_skip_relocation, monterey:       "0982663caa98e50d7936464c7e290ff02e56befde598f839ab3f55543098dfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7018f1c80018a0e80d62288a11d15abdc46dd0ae1a49c096ed7aad9c02ec663c"
  end

  depends_on "rust" => :build

  # Remove after this is resolved:
  # https:github.comcargo-binscargo-binstallpull1781
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end
__END__
diff --git a.cargoconfig.toml b.cargoconfig.toml
index 65dd57802..0a23a07bc 100644
--- a.cargoconfig.toml
+++ b.cargoconfig.toml
@@ -9,8 +9,8 @@ rustflags = ["-C", "link-arg=-fuse-ld=lld"]
 rustflags = ["-C", "link-arg=-fuse-ld=lld"]
 
 [target.x86_64-apple-darwin]
-rustflags = ["-C", "link-arg=-fuse-ld=lld"]
+rustflags = ["-C", "link-arg=-fuse-ld=ld"]
 [target.x86_64h-apple-darwin]
-rustflags = ["-C", "link-arg=-fuse-ld=lld"]
+rustflags = ["-C", "link-arg=-fuse-ld=ld"]
 [target.aarch64-apple-darwin]
-rustflags = ["-C", "link-arg=-fuse-ld=lld"]
+rustflags = ["-C", "link-arg=-fuse-ld=ld"]