class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  sha256 "51f74eb0f51cfa9873b85264dfdd5d46e8957ec95b88f0fb762f63d9e164c72e"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5fe5b4bf293e3358e7f2b176f64373414bec1cdbc64f73765111129d19a9ef52"
    sha256 arm64_sequoia: "c92803efbc90d37ef09db1dd6fb8df4295fa69452097066b0f32e0e58895f739"
    sha256 arm64_sonoma:  "d5b3098faede3e0b74d269dde3f0c571360a4acb04aa0d98ca8c53ccb3102dbd"
    sha256 tahoe:         "9b0fadc6c61e02804f2e1bc8d84e7344fa582745eb4bd30ef5ce4986ffddcc3b"
    sha256 sequoia:       "41529bcf8e41750bf1b14fc59a03d89b0a219db7c1f0c4e45f943c4182db5d87"
    sha256 sonoma:        "906bf2b96c0c9b4ecf640c74fdb36ac171793644f5e47b96a1b9c7c6bc033aaa"
    sha256 arm64_linux:   "8b64bc637ddb9054822f0890283a54d0c54e25606734ec59e3f8592d706f4972"
    sha256 x86_64_linux:  "5f143c0103716ee72ddcee40d88784cf6d474ee6f0322ecfa7ad33880e35255a"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    depends_on "libunistring"
  end

  def install
    system "./configure", "--disable-install-warnings", *std_configure_args
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      info_dir="#{HOMEBREW_PREFIX}/share/info/dir"
      rm -f "$info_dir"
      for file in "#{HOMEBREW_PREFIX}/share/info/"*.info "#{HOMEBREW_PREFIX}/share/info/"*.info.gz; do
        [ -e "$file" ] || continue
        "#{opt_bin}/install-info" --quiet "$file" "$info_dir" || true
      done
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    system bin/"makeinfo", "test.texinfo"
    assert_match "Hello World!", (testpath/"test.info").read
  end
end