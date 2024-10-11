class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https:github.commplewiscsvtomd"
  url "https:files.pythonhosted.orgpackages9d59ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "db9a5f1d08b328f96733905f1b05215a8fe89ff95834ebc873a94d3197e16477"
  end

  depends_on "python@3.13"

  # ValueError: invalid mode: 'rU'
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}csvtomd test.csv").strip
  end
end

__END__
diff --git acsvtomdcsvtomd.py bcsvtomdcsvtomd.py
index a0589a3..137f8da 100755
--- acsvtomdcsvtomd.py
+++ bcsvtomdcsvtomd.py
@@ -146,7 +146,7 @@ def main():
         if filename == '-':
             table = csv_to_table(sys.stdin, args.delimiter)
         else:
-            with open(filename, 'rU') as f:
+            with open(filename, 'r') as f:
                 table = csv_to_table(f, args.delimiter)
         # Print filename for each table if --no-filenames wasn't passed and
         # more than one CSV was provided