class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/57/7d/d4eca5fd33ba5aeb30bb77a5928bb320c46d4f02ba4077481336c5c1475e/gallery_dl-1.26.4.tar.gz"
  sha256 "aa83561fb7e898e40474ecf4fac117b5f85722d3e87d231b0ef40298770e3d7a"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9d3f269712c6c6ab3bf8457d6d3921095ca247bd93c9458ec0dba42b0cfc185"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "373864e1545e374974158b5d05909b8362a33f24d93588a90f060df8771af0f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46cc1774261e4ce1ffbe8611b8bf13f864a3f7a62f2024df70646c17c949b547"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3f5db19f2c7d2e601da3ea5689d7555a5e39a647bc6f7116657ad6cc1c52273"
    sha256 cellar: :any_skip_relocation, ventura:        "a9cbdee0909f3abfd6ee9198dcc46731452f3e17a034ee9bf06410461b2239ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0aea3ab1899a86da0a2a913443e7748b837dd2ef0f44034fb9209517e3a980be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a0fbc3d75c273cad2b0b5f256e968859db082997364e56e61198c0c576819f9"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end