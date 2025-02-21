class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-27.2.4otp_src_27.2.4.tar.gz"
  sha256 "2b98483f73570203015c1d1f87f29c2d0208a8fc7220af2225cf1eb3dfd508f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10bae416c800acbcb61741fd6fcc796e2b3463c59e2093c3c937122a13dc8dbc"
    sha256 cellar: :any,                 arm64_sonoma:  "a5b57ec5f09e53f0f1eb26f96fa8813ae7b3d572927ccb57a8d0d493934372d6"
    sha256 cellar: :any,                 arm64_ventura: "c5e54ba15a565509990bb5e96f7d775a8dd16f88a9897f7130c9b792393262cf"
    sha256 cellar: :any,                 sonoma:        "91c989698c25300fe5292c53f617075e2a60329764c76b1b8f1d8c2d83dc9233"
    sha256 cellar: :any,                 ventura:       "3deaae1984f53b8648044fdafaf8d6318025d4485e82f59eab4a7589987312f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6fcc73208e163420d0c152c32c29929b53a8e0c64b5444e2e4f0ac6d27b124b"
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
    url "https:github.comerlangotpreleasesdownloadOTP-27.2.4otp_doc_html_27.2.4.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_27.2.4.tar.gz"
    sha256 "5042a848deb42f30b2ddf86a2227a46ac1c8b5b58ddf08d206a3e386ac869919"

    livecheck do
      formula :parent
    end
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