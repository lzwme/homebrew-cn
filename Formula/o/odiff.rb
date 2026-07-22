class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://ghfast.top/https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "cfc84f612fecfbce12d25d561a40caa5b916e28406653e22cd15dd826a531f6b"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e8bb183a3fe5b20813cd7d11cdd20ebaf57ee03c30fa181672247d762f54168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc69ea6c18fd87080fbf16c5a02ea90953a002b75b701d50bd401710d14e94b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d2e4fc08a75229cf6b2081885737faa85ca59c8c749dbe381c89f86b1c7065"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a33372c7be711d44c417ce35a4d27828944523d067aca4fb213e38c5524961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cae2494830e33310adbd7c692c9c922de26aed8b5e93c2faefe16f3070dbecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57d454ca811316a0dec6d444cd012741a2fe97075b56bad7b12d14201b54fd6"
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