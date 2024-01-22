class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackagesdd43b5f79a9380dc14cc8220fac8fab7ca03d5b576a475509986ed132a981f36gallery_dl-1.26.7.tar.gz"
  sha256 "f9aa17731255069f675ca4bedfe086ed790331e99282f131317b67476143858b"
  license "GPL-2.0-only"
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7e602456d3be7673dd045825b5adafacb317cd4486e470087db7ab9fbf63101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "162be8aa360bfa9c0a34aa22e329172fd05fbad702f9cb00d108ea1e5b1132ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5faeff8112f3af610f9123e3a4b0515216facce526cf33c851724897198abbf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a5fb8cd27370d262791bbcf10fccd3be32cccda587531c0ee5a7ece71d78d20"
    sha256 cellar: :any_skip_relocation, ventura:        "ffe223e29716ea55fa3d461147128ba2b7839bda6eb698ab64a6312904a637b4"
    sha256 cellar: :any_skip_relocation, monterey:       "56a0f9686046b96dbcf3ab8097063d2812e958a5f2181f8ed5a7f995af1ee14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112f89e91b96ef5ff642d1148d594fcc8b90e626bb44c1d546afe1436586af02"
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