class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20241024.tgz", using: :homebrew_curl
  sha256 "2ad38a70da6b51827c1e4028e12ffd7ec40e6105c4b4256f17382a5139686a48"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b454ecb1d95645914843ccd38e553fb58ae916bde12e1a9b70782fdbcef06fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c1eec9186566572783363f3a044c8c588743890a1afb14166b593ebb95cf92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35538f94fc006b8516a573e5fcd51d65e0018447ab3ea9914f6fa66b68fc1a2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "af7675213f40e7da708812b5dedf3b937604f426e5ebf8cf25c2644d4c928e4a"
    sha256 cellar: :any_skip_relocation, ventura:       "1d8e344b214f6c419b92f5097afb8ef2cde58c3b465c74d30a6a0419eabd0cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694281cc76bc4872e4cbde4ed312f472cc6e9fd7a55a6e7781eeb4fd3863e706"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end