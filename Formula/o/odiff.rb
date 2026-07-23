class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://ghfast.top/https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.4.4.tar.gz"
  sha256 "9261e04f7a09c48bcad1c62f74389649f75eb6be4423e0f6516a48ab08b1e160"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac10e07bfdca6a977200ba6e5c3afc96f8230a16adcd2c6d2a01dfd632cc3021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6930624449a15e43710658a624e08c0b0c1172551b468e071dc82f49dcd71bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2679109bd2f206fb900402582d2a2d21f437b64cff3a750256d1a739460131"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac55a2e0fffe970dc84d275f89f45abd485f086662e7dc9c7618459cd648305f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9993e52f72f19111e98ff1712c78446377a95873a354d34033aebe13910520c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b249ce18a0a085d6a69b70145bfc5ae3ef0f4404038b07e985b12333eb59e71a"
  end

  depends_on "zig" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end