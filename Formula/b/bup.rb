class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://ghfast.top/https://github.com/bup/bup/archive/refs/tags/0.33.8.tar.gz"
  sha256 "5ead4def9c08efb9dff2c2f41e28af3b3c3175c824b28357a4f96e16a258f39f"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9127c8ee7ec2fcf3219047bd567e08c23dbe3003d303953d1f0692e4754f89a"
    sha256 cellar: :any,                 arm64_sonoma:  "33f8062ba9d9149528b5612efcb6f0c8da618474e62880f0ad11d579cb88250e"
    sha256 cellar: :any,                 arm64_ventura: "d537efaa5dc444a73f7de03ba5cfe26091603d3ec5c6fd4c535ce238252b1832"
    sha256 cellar: :any,                 sonoma:        "cc9dac2ba9be76ee97ce1c06d7c301c5faae4e0939cb911584f75d297b9f68db"
    sha256 cellar: :any,                 ventura:       "6b570e924aff4a99bac1ebb29eeffa8b8982acde36cdcdfe2d42b02b75862c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffe10b4b3a9c91bdb83457628100cf4f4961980c0d95b7841636183cda4b6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9aa45bffed901617254b755857b09ab2439c7a05cd3e7f1e2ab55e80520ea9"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_path_exists testpath/".bup"
  end
end