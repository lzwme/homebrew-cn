class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/19/6d/2942ab8c693f2b9f97052d6a6de4c27323a3bd85af7d062dc5bd3a2a9604/gcovr-6.0.tar.gz"
  sha256 "8638d5f44def10e38e3166c8a33bef6643ec204687e0ac7d345ce41a98c5750b"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b85638a70c637af30f7b16f75cdd95fb4b5bfee535e61c8325cba35d90ede23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d391aa2ebe3de2c65ab565af8ec1801c6ebd46fc8de6f4f52e70beb40e5b6671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb573b15c5aedac19a3c46c9ab006e854f2651c219c8c49dd95b6cbdc9018d2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "de9c63bb1ed4a7b78b4af1fad78716fc8c6b258f1b9c657a9e4e25eae551476d"
    sha256 cellar: :any_skip_relocation, ventura:        "360d4c9d26251034b095dce9e28259b7be28685b2882ba88f8e606b6d65cde03"
    sha256 cellar: :any_skip_relocation, monterey:       "3ace6d9ce24206658429329b1eb2ac0a8b50519e5f92f922244e1f912245ff42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01bbe415ac4283725620fbb9b98dd329e5219afe69ab0b06b0a71263a147ad8a"
  end

  depends_on "python-setuptools" => :build
  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-lxml"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end