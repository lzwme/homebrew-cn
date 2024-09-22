class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-27.1otp_src_27.1.tar.gz"
  sha256 "5e65d421c6afcac05c6ef38ee49d6f87e74227f282a639d32e890f6b6c456ec0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62a94855de262f5a747e9e3883525311570fb0ec06d559d0fdf75f1f19a0ccb8"
    sha256 cellar: :any,                 arm64_sonoma:  "fa97e370efddd7abba00e1db18aaf4e42cf900680a6fbf5dddea41b1112e0634"
    sha256 cellar: :any,                 arm64_ventura: "7dfcfbf05139558b31cda7636933d94afab61de044096b236a661bc01d4f450f"
    sha256 cellar: :any,                 sonoma:        "36fa94f6ee1865a839bcf5443f0eeac8ca3d73fb309c5c5d86c109d20b93b25c"
    sha256 cellar: :any,                 ventura:       "30deebcf885d2b10ef8799a409abe688ee4ba823c2434cb1be4f9fbd06084a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81799411e83ea0d0b80d1ad0008e27c14eb75fb9f517c44086dcd42a61c3a4b"
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
    url "https:github.comerlangotpreleasesdownloadOTP-27.1otp_doc_html_27.1.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_27.1.tar.gz"
    sha256 "b0e6d508449eb00f6dd762f5e8ba6eadd0ea3785c79782a3b68c641996d9d168"
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