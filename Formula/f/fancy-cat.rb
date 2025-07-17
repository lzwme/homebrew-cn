class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://ghfast.top/https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28be4cc3f727ed15ab555b774c78c2d4376f4de67cf694f05b5980c638b088d2"
    sha256 cellar: :any,                 arm64_sonoma:  "745862c671df5a51e5ea900ab0cd153ed9cff49ae4efb346b9d8374d8e28c52f"
    sha256 cellar: :any,                 arm64_ventura: "1cb419023d41f8533e4c263cf40ad2a8f84d61e7e7149e660f11a9e8dbcafa07"
    sha256 cellar: :any,                 sonoma:        "490e48aee2397b765da0eeae1030096d9ce673732b41aa1ac3b87b4dc8cfd951"
    sha256 cellar: :any,                 ventura:       "fcae3eaeb13585a561479b0e1e860e6720c1ca983ec6e0e441e336e36d10ce81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aca7669ede29c36af9c3e264185a9da881654a36926a9ef850ff400262cdae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07344d4fbeff7870e19ddb7a4db356b06f5d387f60f184bd82ecb7eff792b43"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end