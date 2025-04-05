class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-27.3.2otp_src_27.3.2.tar.gz"
  sha256 "7997a0900d149c82ae3d0f523d7dfa960ac3cd58acf0b158519c108eb5c65661"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9553f8d4c3b42c691b84088812c4927d96e0f7c739877316ae1c1e5344149db0"
    sha256 cellar: :any,                 arm64_sonoma:  "3ff7b5c23b5e6371d154c789815c0526db97bade8f1c3fdd0f4805c7a3d68845"
    sha256 cellar: :any,                 arm64_ventura: "f7c26de3a607aab765b535b1f83e406283e36868b0bd5910ced7c6cd5d3312c6"
    sha256 cellar: :any,                 sonoma:        "ed7196b0e5f209a377a82b41a4145beba6f7c314ad008504ac3650c23ff1582a"
    sha256 cellar: :any,                 ventura:       "79afcfa2dd55d70e36a6745e126eb94eb2989b98d98b6f3286d900f67ee96b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3561d3a96b35af2f74a4bba1f07103fbc722ab7fcf19dffb9be511346e66ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef9bc9342d938002a5f458d5fc2c836834034797fc0bfeeef52213344419bf7"
  end

  head do
    url "https:github.comerlangotp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

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
    url "https:github.comerlangotpreleasesdownloadOTP-27.3.2otp_doc_html_27.3.2.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_27.3.2.tar.gz"
    sha256 "eef65d2a8cef838640fb4367d657615cac22cd4f2d5c44284943dc714fb1548f"

    livecheck do
      formula :parent
    end
  end

  # https:github.comerlangotpblobOTP-#{version}makeex_doc_link
  resource "ex_doc" do
    url "https:github.comelixir-langex_docreleasesdownloadv0.37.3ex_doc_otp_26"
    sha256 "b127190c72fe456ee4c291d4ca94eb955d0b3c0ca2d061481f65cbf0975e13dc"
  end

  def install
    ex_doc_url = (buildpath"makeex_doc_link").read.strip
    odie "`ex_doc` resource needs updating!" if ex_doc_url != resource("ex_doc").url
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system ".otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
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
    resource("ex_doc").stage do |r|
      (buildpath"bin").install File.basename(r.url) => "ex_doc"
    end
    chmod "+x", "binex_doc"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "install-docs", "DOC_TARGETS=chunks man" }

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