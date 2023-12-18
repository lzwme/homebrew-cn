class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https:github.comlramackup"
  url "https:files.pythonhosted.orgpackages479887dfab0ae5d1abad48a56825585dcd406cdc183dbce930e24ef8439769bamackup-0.8.40.tar.gz"
  sha256 "d267c38719679d4bd162d7f0d0743a51b4da98a5d454d3ec7bb2f3f22e6cadaf"
  license "GPL-3.0-or-later"
  head "https:github.comlramackup.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a078c5b2bc0cb61c80bc8058cbbdb9d955d0480316efeeccedbe96aabc364249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6400e4207eff59cc7f59f72f3615cedfcf409e319ba56e9d50696d877c0d019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa01f419244f2465d567fb383cd7383f34c0f26c4db19d926f3f335e5c3ac0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ade50897a5129abc3c26684f00b1ee1fb384d2413a252ce762df50d3dded343"
    sha256 cellar: :any_skip_relocation, ventura:        "0e781465c87ab1d1c9ebb44442100eab49cad11efa5cab46c55f4781744f38f1"
    sha256 cellar: :any_skip_relocation, monterey:       "27b67474dc527e8125bec2ab02e24153c55b0ad923e3fc6d7d9dee41b3c34e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef78d3ada78aa1149aed572375451333f0d5c981a5621150332f9c6f159c1d4b"
  end

  depends_on "poetry" => :build
  depends_on "python-docopt"
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexecsite_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}mackup", "--help"
  end
end