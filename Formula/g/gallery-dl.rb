class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackages1dff4fb428a6b6f922a0cfd745047f7ded71d838353d5f465a4ca78fa9167a36gallery_dl-1.26.6.tar.gz"
  sha256 "420bf0c47f306f0c5f8d969e6bcf6c20db476d25f222ae571a95948baace5fe9"
  license "GPL-2.0-only"
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2cd877c45cbcd923dc6a79a14d34733ac11f7a9e2b8f03bf16a6f3595dfa2c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea9e2a2cf7dfd33c52f3ce19ae3918064c00847cfd625667d3f3c122fcef926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2736de7e1826a768661b00920e6026089c2ce4769542b4188bbd4b92b1edadc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1a34783dc39ee5adce2769d8e9013accfdc1cf54c9270197c7b7719bce6cce1"
    sha256 cellar: :any_skip_relocation, ventura:        "389273e244eefa5e54b98233ca3b8e05b2624590492f737e70430798f025fdc2"
    sha256 cellar: :any_skip_relocation, monterey:       "0e2b939994d99164cde9b7d9f0c5d2e129d50f0a09dde771ec075251046e6da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b35bacf1c3018ae834f6e3bb858f163fd3bb4e9a16cc9fcd3832c25ac2fc2a5"
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
    system bin"gallery-dl", "https:imgur.comadyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath"gallery-dlimgurdyvohpFimgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end