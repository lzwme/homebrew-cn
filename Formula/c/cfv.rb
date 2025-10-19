class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/29/ca/91cca3d1799d0e74b672e30c41f82a8135fe8d5baf7e6a8af2fdea282449/cfv-3.1.0.tar.gz"
  sha256 "8f352fe4e99837720face2a339ac793f348dd967bacf2a0ff0f5e771340261e3"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "99b44eb32592c111167965c026854d84137dde520cdce0dd4a60f129555ad3e0"
  end

  depends_on "python@3.14"

  def install
    # Fix to error: SystemError: buffer overflow
    # Issue ref: https://github.com/cfv-project/cfv/issues/76
    inreplace "lib/cfv/term.py" do |s|
      s.gsub! "'\\0' * struct.calcsize('h h')", "b'\\\\0' * struct.calcsize('hhhh')"
      s.gsub! "h, w = struct.unpack('h h'", "h, w, _, _ = struct.unpack('hhhh'"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"

    cd "test" do
      assert_match version.to_s, shell_output("#{bin}/cfv --version")

      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_path_exists Pathname.pwd/"test.sha1"
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end