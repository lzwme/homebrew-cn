class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https:github.comgooglecloudplatformgcsfuse"
  url "https:github.comGoogleCloudPlatformgcsfusearchiverefstagsv1.4.1.tar.gz"
  sha256 "6a38ff34c154ab4b35323b338d1cf02453a77078be27f55367180ba41974fffe"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformgcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ab53982a94051360f279fc300c915e2a7443b9b589bff66f2c8e10823fde23b0"
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
    system "#{bin}gcsfuse", "--help"
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