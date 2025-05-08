class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https:github.comgooglecloudplatformgcsfuse"
  url "https:github.comGoogleCloudPlatformgcsfusearchiverefstagsv2.12.0.tar.gz"
  sha256 "b530ef33fd1b0eee5822caab7f594d36237fc7caa546acdeee0d10b15e714726"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformgcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e7e1c78d7ec4ea99e30c3d159d4208caf8cded0d931a1a7c849d1ccd7180c939"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cda40a50839b5c3cf7af861afac8d5cafa08c982430e89e117d489f9933d2af"
  end

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  patch :DATA

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", ".toolsbuild_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system ".build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system bin"gcsfuse", "--help"
    system "#{sbin}mount.gcsfuse", "--help"
  end
end

__END__
diff --git atoolsbuild_gcsfusemain.go btoolsbuild_gcsfusemain.go
index b1a4022..678f747 100644
--- atoolsbuild_gcsfusemain.go
+++ btoolsbuild_gcsfusemain.go
@@ -134,8 +134,6 @@ func buildBinaries(dstDir, srcDir, version string, buildArgs []string) (err erro
 		cmd := exec.Command(
 			"go",
 			"build",
-			"-C",
-			srcDir,
 			"-o",
 			path.Join(dstDir, bin.outputPath))