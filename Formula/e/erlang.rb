class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-27.1.3otp_src_27.1.3.tar.gz"
  sha256 "1b1eb1ed919625caed3dd56e97182956613b3d650556ba1b8b2d6c9bc0c51c28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f18df37e3f8076be76552c5a2b2ca7c10fe2c2ca52333c89df9921af0d555ae"
    sha256 cellar: :any,                 arm64_sonoma:  "4eb868f3249157558e96b6413755ef868b51596ce5d2581c12d397586e094e9e"
    sha256 cellar: :any,                 arm64_ventura: "dd714ad06c73c27194337bd1aa0d77d093449b25dec605f441fcbd2ea09b76f8"
    sha256 cellar: :any,                 sonoma:        "00e74e533d04ef6fb45aabf546443f4b0bb52b975f917a41ab815c7792827a3f"
    sha256 cellar: :any,                 ventura:       "860a0e70072cfefce2d5d300229d36085c3a9ddbea2f74767d1bae99878a7660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db04d3630dd97aaca728cbff3221864558af25eddf328db5797441493fbff07"
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
    url "https:github.comerlangotpreleasesdownloadOTP-27.1.3otp_doc_html_27.1.3.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_27.1.3.tar.gz"
    sha256 "16119a187a530e297aa52a5d2d009c9b6d23c879adfd4ebc6a5fd029e50959f3"
  end

  # https:github.comerlangotpblob#{version}makeex_doc_link
  resource "ex_doc" do
    url "https:github.comelixir-langex_docreleasesdownloadv0.34.1ex_doc_otp_26"
    sha256 "d1e09ef6772132f36903fbb1c13d6972418b74ff2da71ab8e60fa3770fc56ec7"
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