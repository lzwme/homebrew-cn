class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://ghfast.top/https://github.com/roswell/roswell/archive/refs/tags/v26.10.117.tar.gz"
  sha256 "b5f82ea8e331161988d55915fcb5b45f0cfbeff04b1e4655806412ab21006118"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "258823e419b8251ffda1ce1ae0f8466d17c5ca25b0907760edfe5c7d4d635980"
    sha256 arm64_tahoe:       "3fc2601cb0d4fa92801afc570583284470cda6e40b5114f5a24b08666f1a17db"
    sha256 arm64_sequoia:     "82f1cfea48b81c06dff578e3d0ac6358ae2b9c6f239c008c554f13f767cbf375"
    sha256 arm64_linux:       "d17a7b94137c1f35ec3a7c2fddbbecf725f6a6b49458a390055ff92f2e58efc2"
    sha256 x86_64_linux:      "84eb3ac6d9a760c0b0b262e5731b2b7bf0a7d72510560df6f5f804364dd4b3cb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_path_exists testpath/"config"
  end
end