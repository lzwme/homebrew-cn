class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.19otp_src_25.3.2.19.tar.gz"
  sha256 "24e9b6c3dc4926619b82be4f46abdd757055fedd386f89b724f3e59573e5d1c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(25(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a9a2b156b2310fa15902f6dd73b60a4b5e49e73f33dd4d10dbb3c72def1a415"
    sha256 cellar: :any,                 arm64_sonoma:  "3ef91bc78f2a6b24c84221d439c9cfd30935e0fa6d213d8815a458724f85cc78"
    sha256 cellar: :any,                 arm64_ventura: "e269fcc93ab3ed2bf098199ac2d332a8c0b16b05ad71f7903ed4c2b365ec6a80"
    sha256 cellar: :any,                 sonoma:        "6bc02a86560606f14f1e4ec6604c08123673b0931fcc8d36eb135ec2ecd332c0"
    sha256 cellar: :any,                 ventura:       "c4f088fe9f64097e7eea0f9e490fbb51b70b78638bed4a05f71dbe8543270451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8341afaec34757967863f9419d526d217e50b76c096247d444aee14e39de9f15"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.19otp_doc_html_25.3.2.19.tar.gz"
    sha256 "8f7b2ece491212c018211e9f70e09e99b6dd978bfa58dda752c30a79bc244ff7"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system ".otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system ".configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}erlangman

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system bin"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

    (testpath"factorial").write <<~EOS
      #!#{bin}escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS

    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output(".factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output(".factorial 42")
  end
end