class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.9otp_src_26.2.5.9.tar.gz"
  sha256 "fb626d82c6a4fb7a85db8f8f12c8689ad669791d58982f91b05d226785b56175"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(26(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d8c01adea8a9c144f1a0b4f649889671c3b78d7b5ca5c6fcc32bf105ea6a8c3"
    sha256 cellar: :any,                 arm64_sonoma:  "6574c7cf4c9c51d4621a6e659f519f175b535dfda9e4e3d1130f31127c565c87"
    sha256 cellar: :any,                 arm64_ventura: "16dcf302200e297a9bd59a46479b2bf1c8e4eb49b3b2e70ac032ad11ffdf9e4b"
    sha256 cellar: :any,                 sonoma:        "0ae7b6255df697ad195711c65719b7aaecb944fea111b7aa3c6e4f249917a12d"
    sha256 cellar: :any,                 ventura:       "d4e0eff50bb7897f1f90dec3c33ed2a8e23cd68d795eeaff5dcd4e703c190633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f88e43bdd33ad2dce2716d1ee8c2cedd3a96fdf708f4ea673967c6c628c72134"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.9otp_doc_html_26.2.5.9.tar.gz"
    sha256 "18410b5df66236c5dde384692cd344b32d6a85301d4e0ed00d2d98c9774ade88"

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

    system ".configure", *std_configure_args, *args
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