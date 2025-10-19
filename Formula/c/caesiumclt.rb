class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://ghfast.top/https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e612843b21a431ca2be68b3060f4c88be82c2219ec09041be9fbf17ed38c33ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a29984f733d930a8b9839cc14664b0cb220adc3bb281819f3ea7168ee44b7935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1566d7c2f4c7c33f25f6ca74b88baff5fc83f131c17e775c196613a2f87054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2006c6a768eab8e1edb87df17d895e770c7e27c929e749823a35a30df4d5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f704fd864b1438ca7a865cca72814432deb879083cb93500187fc53a196e29e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204bbf452a2c11051da3aa3409f397d41777e421416398f184bfe3b3d3000ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4463851340f9eedcfc2e0dbdef24f99983d0d4ab9d4b92084211372a64093fce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"caesiumclt", "--lossless", "-Q", "--suffix", "_t", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_t.jpg"
    system bin/"caesiumclt", "-q", "80", "-Q", "--suffix", "_b", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_b.jpg"
  end
end