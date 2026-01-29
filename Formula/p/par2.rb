class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://ghfast.top/https://github.com/Parchive/par2cmdline/releases/download/v1.1.0/par2cmdline-1.1.0.tar.bz2"
  sha256 "72db917f0e73c44833f6f8b4fb407d872076cc38daf111064ffcb852f674c4c1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c7e8a64d6d534465f27bd0ebcf7d977ef6e055c9e49d1ea6f49b10e6721f0c5"
    sha256 cellar: :any,                 arm64_sequoia: "a135b8d4b092bed280aed91b37bfedc53e7f536e8f7cebfc886687b6d82d190c"
    sha256 cellar: :any,                 arm64_sonoma:  "adbdf5ea1e0b48050481f0927d809dd752da9a76895dbccb3ec906dddb0409f7"
    sha256 cellar: :any,                 sonoma:        "e113ba52a622894780611dc348ebb7f9ce9942faa89fa57b4977d06d78b0092a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c637538062fcb34f58e6c086eba5e71f2eaa7b335ed9cb2483be6f265a406a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876c356840164ad19ac9b1da113f7e1713101c83c0f1f14d62d5b520f5d09dc0"
  end

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV.append_to_cflags "-Xpreprocessor -fopenmp -I#{libomp.opt_include} -L#{libomp.opt_lib} -lomp"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
    File.write(test_file, "file contents")
    system bin/"par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write(test_file, "corrupted contents")
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert_equal "file contents", File.read(test_file)
  end
end