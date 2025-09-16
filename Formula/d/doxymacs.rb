class Doxymacs < Formula
  desc "Elisp package for using doxygen under Emacs"
  homepage "https://doxymacs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz"
  sha256 "a23fd833bc3c21ee5387c62597610941e987f9d4372916f996bf6249cc495afa"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c8cd54abb531fe75440204a59834ef7807442cd7d8543f1335fb4c6428977421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d6f35d29f2d9bf0ab3a13916922b7fb4506e133d83fe26c10b00fe0c6c27be17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa03231378a72916d1f1bdb3c63d47751fd1891d9d92daa680b44cbf80e3ce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "699c57cf8869c5eda84db1f8d58a160c6c821015c1c7bc4892d5ad2f1447c73e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c79209e9d8c2f8e47a4e6e28993954250060f74717a749e48ea04b381b63a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffe57742c559c3ef80b3bf338d2903c7fc0137d4d9cc96f2b23bea2e0cab832"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8870836bd8052c49da1d950c863efc99d804be590ae85f2fd6c5176d65ec177"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ff086ebd4cdeb4945b9a67de2c74a6d22f47e84db58b17597ea5d6ef6d0fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "dba8d6a64b38ed2b2912d6ecc9fa0e895bfbeffb06255a183676f6be56c55c63"
    sha256 cellar: :any_skip_relocation, big_sur:        "761f34a12276f673ad5914b0b9caa8891eaab8fb213292a897e1000375a0370a"
    sha256 cellar: :any_skip_relocation, catalina:       "060a755f85149143e0aea876b488f98e685e320c7ced43d3ae87dfcbd4931f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe41948e3c5a21e01c2db606c4001bc17a9f3a5e610da7adefad289bc521420a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c2ebbdf243dded3a23783b3a22ee3705a53dd0ba50c292dcb190bb5bcebc9a"
  end

  head do
    url "https://git.code.sf.net/p/doxymacs/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "doxygen"
  depends_on "emacs"

  uses_from_macos "libxml2"

  def install
    # https://sourceforge.net/p/doxymacs/support-requests/5/
    ENV.append "CFLAGS", "-std=gnu89"

    # Fix undefined symbol errors for _xmlCheckVersion, etc.
    # This prevents a mismatch between /usr/bin/xml2-config and the SDK headers,
    # which would cause the build system not to pass the LDFLAGS for libxml2.
    ENV.prepend_path "PATH", "#{MacOS.sdk_path}/usr/bin" if OS.mac?

    system "./bootstrap" if build.head?
    system "./configure", "--with-lispdir=#{elisp}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<~LISP
      (add-to-list 'load-path "#{elisp}")
      (load "doxymacs")
      (print doxymacs-version)
    LISP

    output = shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    assert_equal "\"#{version}\"", output
  end
end