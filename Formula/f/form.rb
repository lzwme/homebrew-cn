class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://ghfast.top/https://github.com/form-dev/form/releases/download/v5.0.0/form-5.0.0.tar.gz"
  sha256 "10d22acf2f0acf831b494e6a73682828980b9054ea8ec2b5dc46677dca8d6518"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a51453b7d9db299d5e3a952ef662df7fff36998798529e0e521e187acb944b0"
    sha256 cellar: :any,                 arm64_sequoia: "67c1e4e94dab3c4e15240846106c7c324649440406571491448ac7b12202eaf3"
    sha256 cellar: :any,                 arm64_sonoma:  "fe7861af0557ce649d0ddfa2d5519fef77ba640683eba01c42df6da3f5a5128c"
    sha256 cellar: :any,                 sonoma:        "7d1945e672162a5aca46fdf069a224c83fdc498f62dc06fc47fec612744b83f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37e47b7e8e866f1a05744ebd993ca8db1d3c5f59f01c9cb9e2a4393dda21604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7452db7be5b86008708893949d2bc6435e13ec7dd9e620ab54fe5c43d00edaae"
  end

  depends_on "gmp"
  depends_on "mpfr"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-native"
    system "make", "install"
  end

  test do
    (testpath/"test.frm").write <<~EOS
      Symbol x,n;
      Local E = x^10;

      repeat id x^n?{>1} = x^(n-1) + x^(n-2);

      Print;
      .end
    EOS

    expected_match = /E\s*=\s*34 \+ 55\*x;/
    assert_match expected_match, shell_output("#{bin}/form #{testpath}/test.frm")
    assert_match expected_match, shell_output("#{bin}/tform #{testpath}/test.frm")
  end
end