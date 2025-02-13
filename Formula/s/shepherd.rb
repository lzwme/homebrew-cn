class Shepherd < Formula
  desc "Service manager that looks after the herd of system services"
  homepage "https://www.gnu.org/software/shepherd/"
  url "https://ftp.gnu.org/gnu/shepherd/shepherd-1.0.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/shepherd/shepherd-1.0.2.tar.gz"
  sha256 "df4bac04b4b0476fa8f9ed138292ac2cc54b4304b5eefd859ed4892d4f9924bf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "dc41c6141d34f0d078c499a48cb43277f6bb5894316b4a542e411b2730833963"
    sha256 arm64_sonoma:  "dc41c6141d34f0d078c499a48cb43277f6bb5894316b4a542e411b2730833963"
    sha256 arm64_ventura: "dc41c6141d34f0d078c499a48cb43277f6bb5894316b4a542e411b2730833963"
    sha256 sonoma:        "7aad4075a39f8e377af603e4d1b4f040bed2ad05ab0d24fc2739414e822f09bb"
    sha256 ventura:       "7aad4075a39f8e377af603e4d1b4f040bed2ad05ab0d24fc2739414e822f09bb"
    sha256 x86_64_linux:  "5b10b8b43d4b61f87d029fd7cfa2135b82acb3268b0ac57d5c1732bc0118f914"
  end

  depends_on "pkgconf" => :build
  depends_on "guile"
  depends_on "guile-fibers"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["GUILE_LOAD_PATH"] = Formula["guile-fibers"].opt_share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = Formula["guile-fibers"].opt_lib/"guile/3.0/site-ccache"

    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dummy-service.scm").write <<~SCHEME
      (use-modules (shepherd service))

      (define dummy-service
        (service
         (provision '(dummy))
         (start (lambda ()
                  (format #t "Dummy service started~%")
                  (values)))
         (stop (lambda ()
                 (format #t "Dummy service stopped~%")
                 (values)))))

      (register-services dummy-service)
    SCHEME

    begin
      pid = spawn bin/"shepherd", "-c", "dummy-service.scm"
      sleep 2

      output = shell_output("#{bin}/herd status 2>&1", 1)
      assert_match "socket: No such file or directory", output

      assert_match version.to_s, shell_output("#{bin}/herd --version")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end